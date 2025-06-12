/**
 * 文件验证工具
 * 提供文件安全性检查和内容验证功能
 */

const fs = require('fs').promises;
const path = require('path');
const crypto = require('crypto');
const logger = require('../config/modules/logger');

class FileValidator {
  /**
   * MIME类型白名单
   */
  static ALLOWED_MIME_TYPES = {
    images: ['image/jpeg', 'image/jpg', 'image/png'],
    documents: ['application/pdf'],
    all: ['image/jpeg', 'image/jpg', 'image/png', 'application/pdf']
  };

  /**
   * 文件扩展名白名单
   */
  static ALLOWED_EXTENSIONS = {
    images: ['.jpg', '.jpeg', '.png'],
    documents: ['.pdf'],
    all: ['.jpg', '.jpeg', '.png', '.pdf']
  };

  /**
   * 最大文件大小（字节）
   */
  static MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB

  /**
   * 恶意文件签名（魔数）
   */
  static MALICIOUS_SIGNATURES = [
    // 可执行文件
    '4d5a',     // PE files (exe, dll)
    '7f454c46', // ELF files (Linux executables)
    'cafebabe', // Java class files
    // 脚本文件的常见开头
    '3c3f706870', // <?php
    '3c736372697074', // <script
    // ZIP文件（可能包含恶意内容）
    '504b0304', // ZIP files
    '504b0506', // ZIP files (empty)
    '504b0708'  // ZIP files
  ];

  /**
   * 验证文件基本信息
   * @param {Object} fileInfo - 文件信息
   * @param {String} fileInfo.fileName - 文件名
   * @param {String} fileInfo.mimeType - MIME类型
   * @param {Number} fileInfo.fileSize - 文件大小
   * @param {String} fileInfo.fileUrl - 文件URL（可选）
   * @returns {Object} 验证结果
   */
  static validateFileInfo(fileInfo) {
    const errors = [];

    // 验证文件名
    if (!fileInfo.fileName || typeof fileInfo.fileName !== 'string') {
      errors.push('文件名不能为空');
    } else {
      // 检查文件名长度
      if (fileInfo.fileName.length > 255) {
        errors.push('文件名过长（最多255个字符）');
      }

      // 检查文件名中的危险字符
      const dangerousChars = /[<>:"/\\|?*\x00-\x1f]/;
      if (dangerousChars.test(fileInfo.fileName)) {
        errors.push('文件名包含非法字符');
      }

      // 检查文件扩展名
      const ext = path.extname(fileInfo.fileName).toLowerCase();
      if (!this.ALLOWED_EXTENSIONS.all.includes(ext)) {
        errors.push(`不支持的文件格式：${ext}`);
      }
    }

    // 验证MIME类型
    if (!fileInfo.mimeType || typeof fileInfo.mimeType !== 'string') {
      errors.push('MIME类型不能为空');
    } else if (!this.ALLOWED_MIME_TYPES.all.includes(fileInfo.mimeType)) {
      errors.push(`不支持的文件类型：${fileInfo.mimeType}`);
    }

    // 验证文件大小
    if (!fileInfo.fileSize || typeof fileInfo.fileSize !== 'number') {
      errors.push('文件大小必须是有效数字');
    } else {
      if (fileInfo.fileSize <= 0) {
        errors.push('文件大小必须大于0');
      }
      if (fileInfo.fileSize > this.MAX_FILE_SIZE) {
        errors.push(`文件大小超过限制（最大${this.MAX_FILE_SIZE / 1024 / 1024}MB）`);
      }
    }

    // 验证文件扩展名与MIME类型的一致性
    if (fileInfo.fileName && fileInfo.mimeType) {
      const ext = path.extname(fileInfo.fileName).toLowerCase();
      const isValidCombination = this.validateExtensionMimeMatch(ext, fileInfo.mimeType);
      if (!isValidCombination) {
        errors.push('文件扩展名与文件类型不匹配');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }

  /**
   * 验证文件扩展名与MIME类型的匹配性
   * @param {String} extension - 文件扩展名
   * @param {String} mimeType - MIME类型
   * @returns {Boolean} 是否匹配
   */
  static validateExtensionMimeMatch(extension, mimeType) {
    const validCombinations = {
      '.jpg': ['image/jpeg', 'image/jpg'],
      '.jpeg': ['image/jpeg', 'image/jpg'],
      '.png': ['image/png'],
      '.pdf': ['application/pdf']
    };

    const allowedMimeTypes = validCombinations[extension.toLowerCase()];
    return allowedMimeTypes && allowedMimeTypes.includes(mimeType);
  }

  /**
   * 验证文件内容（基于文件头）
   * @param {Buffer|String} fileContent - 文件内容或文件路径
   * @param {String} expectedMimeType - 期望的MIME类型
   * @returns {Promise<Object>} 验证结果
   */
  static async validateFileContent(fileContent, expectedMimeType) {
    try {
      let buffer;
      
      // 如果传入的是文件路径，读取文件内容
      if (typeof fileContent === 'string') {
        buffer = await fs.readFile(fileContent);
      } else if (Buffer.isBuffer(fileContent)) {
        buffer = fileContent;
      } else {
        return {
          isValid: false,
          errors: ['无效的文件内容格式']
        };
      }

      const errors = [];

      // 检查文件是否为空
      if (buffer.length === 0) {
        errors.push('文件内容为空');
      }

      // 获取文件头（前16字节）
      const header = buffer.slice(0, 16);
      const headerHex = header.toString('hex').toLowerCase();

      // 检查恶意文件签名
      for (const signature of this.MALICIOUS_SIGNATURES) {
        if (headerHex.startsWith(signature)) {
          errors.push('检测到可疑文件格式');
          logger.warn('检测到可疑文件', { 
            signature, 
            headerHex: headerHex.substring(0, 16) 
          });
          break;
        }
      }

      // 验证文件头与MIME类型的匹配性
      const actualMimeType = this.detectMimeTypeFromHeader(headerHex);
      if (actualMimeType && actualMimeType !== expectedMimeType) {
        errors.push(`文件实际类型（${actualMimeType}）与声明类型（${expectedMimeType}）不匹配`);
      }

      // 检查文件完整性（基本检查）
      if (!this.isFileIntegrityValid(buffer, expectedMimeType)) {
        errors.push('文件可能已损坏或格式不正确');
      }

      return {
        isValid: errors.length === 0,
        errors,
        actualMimeType,
        fileSize: buffer.length,
        headerSignature: headerHex.substring(0, 16)
      };

    } catch (error) {
      logger.error('文件内容验证失败', { error: error.message });
      return {
        isValid: false,
        errors: ['文件内容验证过程中发生错误']
      };
    }
  }

  /**
   * 根据文件头检测MIME类型
   * @param {String} headerHex - 文件头的十六进制字符串
   * @returns {String|null} 检测到的MIME类型
   */
  static detectMimeTypeFromHeader(headerHex) {
    // 常见文件格式的魔数
    const signatures = {
      'ffd8ff': 'image/jpeg',     // JPEG
      '89504e47': 'image/png',    // PNG
      '25504446': 'application/pdf', // PDF
      '504b0304': 'application/zip', // ZIP
      '504b0506': 'application/zip', // ZIP (empty)
      '504b0708': 'application/zip'  // ZIP
    };

    for (const [signature, mimeType] of Object.entries(signatures)) {
      if (headerHex.startsWith(signature)) {
        return mimeType;
      }
    }

    return null;
  }

  /**
   * 检查文件完整性
   * @param {Buffer} buffer - 文件内容
   * @param {String} mimeType - MIME类型
   * @returns {Boolean} 文件是否完整
   */
  static isFileIntegrityValid(buffer, mimeType) {
    try {
      switch (mimeType) {
        case 'image/jpeg':
        case 'image/jpg':
          // JPEG文件应该以FFD8开头，以FFD9结尾
          return buffer[0] === 0xFF && buffer[1] === 0xD8 &&
                 buffer[buffer.length - 2] === 0xFF && buffer[buffer.length - 1] === 0xD9;
          
        case 'image/png':
          // PNG文件应该以89504E47开头，以49454E44结尾
          return buffer[0] === 0x89 && buffer[1] === 0x50 && buffer[2] === 0x4E && buffer[3] === 0x47 &&
                 buffer[buffer.length - 8] === 0x49 && buffer[buffer.length - 7] === 0x45 && 
                 buffer[buffer.length - 6] === 0x4E && buffer[buffer.length - 5] === 0x44;
          
        case 'application/pdf':
          // PDF文件应该以%PDF开头
          const pdfHeader = buffer.slice(0, 4).toString();
          return pdfHeader === '%PDF';
          
        default:
          return true; // 对于未知类型，假设完整
      }
    } catch (error) {
      logger.warn('文件完整性检查失败', { error: error.message, mimeType });
      return false;
    }
  }

  /**
   * 计算文件哈希值
   * @param {Buffer|String} fileContent - 文件内容或文件路径
   * @param {String} algorithm - 哈希算法（默认sha256）
   * @returns {Promise<String>} 文件哈希值
   */
  static async calculateFileHash(fileContent, algorithm = 'sha256') {
    try {
      let buffer;
      
      if (typeof fileContent === 'string') {
        buffer = await fs.readFile(fileContent);
      } else if (Buffer.isBuffer(fileContent)) {
        buffer = fileContent;
      } else {
        throw new Error('无效的文件内容格式');
      }

      const hash = crypto.createHash(algorithm);
      hash.update(buffer);
      return hash.digest('hex');
      
    } catch (error) {
      logger.error('计算文件哈希失败', { error: error.message });
      throw error;
    }
  }

  /**
   * 综合文件验证
   * @param {Object} fileInfo - 文件信息
   * @param {Buffer|String} fileContent - 文件内容（可选）
   * @returns {Promise<Object>} 验证结果
   */
  static async validateFile(fileInfo, fileContent = null) {
    const results = {
      isValid: true,
      errors: [],
      warnings: []
    };

    // 基本信息验证
    const basicValidation = this.validateFileInfo(fileInfo);
    if (!basicValidation.isValid) {
      results.isValid = false;
      results.errors.push(...basicValidation.errors);
    }

    // 文件内容验证（如果提供了内容）
    if (fileContent && basicValidation.isValid) {
      const contentValidation = await this.validateFileContent(fileContent, fileInfo.mimeType);
      if (!contentValidation.isValid) {
        results.isValid = false;
        results.errors.push(...contentValidation.errors);
      } else {
        results.fileHash = await this.calculateFileHash(fileContent);
        results.actualMimeType = contentValidation.actualMimeType;
        results.headerSignature = contentValidation.headerSignature;
      }
    }

    return results;
  }
}

module.exports = FileValidator;