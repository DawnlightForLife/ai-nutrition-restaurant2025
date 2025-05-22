/**
 * MongoDB 模式迁移管理器服务
 * 提供自动迁移、手动创建迁移、回滚迁移、备份集合等功能
 * 用于维护数据库结构的可追溯性与自动变更能力
 * 与 ModelFactory 配合使用，确保模型演化过程安全可控
 * @module services/core/migrationManagerService
 */
/**
 * 迁移管理器服务 - 处理MongoDB模式迁移
 * 提供自动化迁移生成、应用和回滚功能
 */
const mongoose = require('mongoose');
const { EventEmitter } = require('events');
const fs = require('fs').promises;
const path = require('path');
const logger = require('../../utils/logger/winstonLogger.js');

class MigrationManagerService extends EventEmitter {
  constructor(options = {}) {
    super();
    this.initialized = false;
    this.config = {
      migrationsDir: options.migrationsDir || path.join(process.cwd(), 'migrations'),
      autoMigrate: options.autoMigrate || false,
      migrationCollection: options.migrationCollection || 'migrations',
      backupBeforeMigration: options.backupBeforeMigration !== false,
      ...options
    };
    
    this.pendingMigrations = [];
    this.appliedMigrations = [];
    this.logger = logger.child({ service: 'MigrationManagerService' });
  }

  /**
   * 初始化服务
   */
  async initialize() {
    try {
      if (this.initialized) {
        this.logger.warn('服务已经初始化');
        return true;
      }
      
      this.logger.info('初始化MigrationManagerService', { config: this.config });
      
      // 确保迁移目录存在
      await this._ensureMigrationsDirExists();
      
      // 设置迁移集合
      await this._setupMigrationCollection();
      
      // 加载已应用的迁移
      await this._loadAppliedMigrations();
      
      // 加载待处理的迁移
      await this._loadPendingMigrations();
      
      // 如果配置了自动迁移，应用所有待处理的迁移
      if (this.config.autoMigrate && this.pendingMigrations.length > 0) {
        this.logger.info('自动应用迁移', { count: this.pendingMigrations.length });
        await this.applyPendingMigrations();
      }
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('MigrationManagerService初始化完成');
      return true;
    } catch (error) {
      this.logger.error('初始化MigrationManagerService失败', { error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 确保迁移目录存在
   */
  async _ensureMigrationsDirExists() {
    try {
      await fs.mkdir(this.config.migrationsDir, { recursive: true });
      this.logger.debug('确保迁移目录存在', { dir: this.config.migrationsDir });
      return true;
    } catch (error) {
      this.logger.error('确保迁移目录存在失败', { error });
      throw error;
    }
  }

  /**
   * 设置迁移集合
   */
  async _setupMigrationCollection() {
    try {
      // 检查迁移集合是否存在
      const collections = await mongoose.connection.db
        .listCollections({ name: this.config.migrationCollection })
        .toArray();
      
      if (collections.length === 0) {
        // 创建迁移集合
        await mongoose.connection.db.createCollection(this.config.migrationCollection);
        
        // 创建索引
        await mongoose.connection.db.collection(this.config.migrationCollection).createIndex(
          { name: 1 },
          { unique: true }
        );
        
        await mongoose.connection.db.collection(this.config.migrationCollection).createIndex(
          { appliedAt: -1 }
        );
        
        this.logger.info('创建迁移集合', { collection: this.config.migrationCollection });
      }
      
      return true;
    } catch (error) {
      this.logger.error('设置迁移集合失败', { error });
      throw error;
    }
  }

  /**
   * 加载已应用的迁移
   */
  async _loadAppliedMigrations() {
    try {
      this.appliedMigrations = await mongoose.connection.db
        .collection(this.config.migrationCollection)
        .find({})
        .sort({ appliedAt: -1 })
        .toArray();
      
      this.logger.debug('加载已应用的迁移', { count: this.appliedMigrations.length });
      return this.appliedMigrations;
    } catch (error) {
      this.logger.error('加载已应用的迁移失败', { error });
      throw error;
    }
  }

  /**
   * 加载待处理的迁移
   */
  async _loadPendingMigrations() {
    try {
      // 获取迁移目录中的所有文件
      const files = await fs.readdir(this.config.migrationsDir);
      
      // 过滤出JavaScript文件
      const migrationFiles = files.filter(file => file.endsWith('.js'));
      
      // 创建已应用迁移名称集合，用于快速查找
      const appliedMigrationNames = new Set(this.appliedMigrations.map(m => m.name));
      
      // 过滤出未应用的迁移
      this.pendingMigrations = [];
      
      for (const file of migrationFiles) {
        const name = file.replace('.js', '');
        
        if (!appliedMigrationNames.has(name)) {
          // 加载迁移文件
          try {
            const migrationPath = path.join(this.config.migrationsDir, file);
            const migration = require(migrationPath);
            
            if (typeof migration.up !== 'function' || typeof migration.down !== 'function') {
              this.logger.warn('迁移文件格式不正确', { file });
              continue;
            }
            
            this.pendingMigrations.push({
              name,
              path: migrationPath,
              migration
            });
          } catch (err) {
            this.logger.error('加载迁移文件失败', { file, error: err });
          }
        }
      }
      
      // 按名称排序
      this.pendingMigrations.sort((a, b) => a.name.localeCompare(b.name));
      
      this.logger.debug('加载待处理的迁移', { count: this.pendingMigrations.length });
      return this.pendingMigrations;
    } catch (error) {
      this.logger.error('加载待处理的迁移失败', { error });
      throw error;
    }
  }

  /**
   * 创建迁移文件
   */
  async createMigration(name, description, changes) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      // 格式化迁移名称
      const timestamp = new Date().getTime();
      const formattedName = `${timestamp}_${name.replace(/[^a-zA-Z0-9]/g, '_')}`;
      
      // 创建迁移文件内容
      let content = `/**
 * 迁移: ${formattedName}
 * 描述: ${description || ''}
 * 创建时间: ${new Date().toISOString()}
 */

const mongoose = require('mongoose');

module.exports = {
  /**
   * 应用迁移
   */
  async up(db) {
    // 实现迁移逻辑
`;

      // 根据变更生成迁移代码
      if (changes) {
        content += this._generateMigrationCode(changes);
      } else {
        content += `    // TODO: 实现迁移逻辑\n`;
      }

      content += `
    return { success: true };
  },

  /**
   * 回滚迁移
   */
  async down(db) {
    // 实现回滚逻辑
    return { success: true };
  }
};
`;

      // 创建迁移文件
      const filePath = path.join(this.config.migrationsDir, `${formattedName}.js`);
      await fs.writeFile(filePath, content);
      
      this.logger.info('创建迁移文件', { name: formattedName, path: filePath });
      
      // 重新加载待处理的迁移
      await this._loadPendingMigrations();
      
      this.emit('migrationCreated', { name: formattedName, path: filePath });
      
      return {
        name: formattedName,
        path: filePath
      };
    } catch (error) {
      this.logger.error('创建迁移文件失败', { name, error });
      throw error;
    }
  }

  /**
   * 根据变更生成迁移代码
   */
  _generateMigrationCode(changes) {
    let code = '';
    
    if (changes.added && changes.added.length > 0) {
      code += `    // 添加新字段\n`;
      
      for (const field of changes.added) {
        code += `    await db.collection('${changes.collection}').updateMany({}, { $set: { "${field.path}": ${this._getDefaultValue(field.type)} } });\n`;
      }
      
      code += '\n';
    }
    
    if (changes.removed && changes.removed.length > 0) {
      code += `    // 删除字段\n`;
      
      for (const field of changes.removed) {
        code += `    await db.collection('${changes.collection}').updateMany({}, { $unset: { "${field}": "" } });\n`;
      }
      
      code += '\n';
    }
    
    if (changes.modified && changes.modified.length > 0) {
      code += `    // 修改字段\n`;
      
      for (const field of changes.modified) {
        if (field.oldType !== field.newType) {
          code += `    // 将字段 ${field.path} 从 ${field.oldType} 转换为 ${field.newType}\n`;
          code += `    await db.collection('${changes.collection}').find({}).forEach(doc => {
      const newValue = this._convertValue(doc.${field.path}, '${field.oldType}', '${field.newType}');
      db.collection('${changes.collection}').updateOne({ _id: doc._id }, { $set: { "${field.path}": newValue } });
    });\n`;
        }
      }
      
      code += '\n';
    }
    
    if (changes.indexChanges) {
      code += `    // 更新索引\n`;
      
      // 删除旧索引
      if (changes.indexChanges.old && changes.indexChanges.old.length > 0) {
        for (const index of changes.indexChanges.old) {
          const indexName = this._getIndexName(index);
          code += `    await db.collection('${changes.collection}').dropIndex("${indexName}");\n`;
        }
      }
      
      // 创建新索引
      if (changes.indexChanges.new && changes.indexChanges.new.length > 0) {
        for (const index of changes.indexChanges.new) {
          const indexFields = JSON.stringify(index[0]);
          const indexOptions = JSON.stringify(index[1] || {});
          code += `    await db.collection('${changes.collection}').createIndex(${indexFields}, ${indexOptions});\n`;
        }
      }
    }
    
    return code;
  }

  /**
   * 获取默认值
   */
  _getDefaultValue(type) {
    switch (type) {
      case 'String':
        return '""';
      case 'Number':
        return '0';
      case 'Boolean':
        return 'false';
      case 'Date':
        return 'new Date()';
      case 'Array':
        return '[]';
      case 'Object':
        return '{}';
      default:
        return 'null';
    }
  }

  /**
   * 获取索引名称
   */
  _getIndexName(index) {
    if (index[1] && index[1].name) {
      return index[1].name;
    }
    
    // 生成索引名称
    const fields = Object.keys(index[0]);
    return fields.map(field => `${field}_${index[0][field] === 1 ? 'asc' : 'desc'}`).join('_');
  }

  /**
   * 应用待处理的迁移
   */
  async applyPendingMigrations() {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      if (this.pendingMigrations.length === 0) {
        this.logger.info('没有待处理的迁移');
        return { applied: 0 };
      }
      
      this.logger.info('应用待处理的迁移', { count: this.pendingMigrations.length });
      
      const results = {
        success: [],
        failed: []
      };
      
      // 应用每个迁移
      for (const pendingMigration of this.pendingMigrations) {
        try {
          this.logger.info('应用迁移', { name: pendingMigration.name });
          
          // 如果配置了在迁移前备份
          if (this.config.backupBeforeMigration) {
            await this._backupCollection(pendingMigration);
          }
          
          // 应用迁移
          const result = await pendingMigration.migration.up(mongoose.connection.db);
          
          // 记录迁移应用
          await this._recordMigration(pendingMigration.name, result);
          
          results.success.push(pendingMigration.name);
          this.emit('migrationApplied', { name: pendingMigration.name, result });
          } catch (error) {
            this.logger.error('应用迁移失败', { name: pendingMigration.name, error });
            results.failed.push({ name: pendingMigration.name, error: error.message });
            this.emit('migrationError', { name: pendingMigration.name, error });
            
            // 如果配置了在出错时停止
            if (this.config.stopOnError) {
              break;
            }
          }
      }
      
      // 重新加载迁移
      await this._loadAppliedMigrations();
      await this._loadPendingMigrations();
      
      this.logger.info('应用待处理的迁移完成', { 
        success: results.success.length, 
        failed: results.failed.length 
      });
      
      return {
        applied: results.success.length,
        failed: results.failed.length,
        results
      };
    } catch (error) {
      this.logger.error('应用待处理的迁移失败', { error });
      throw error;
    }
  }

  /**
   * 备份集合
   */
  async _backupCollection(migration) {
    try {
      // 分析迁移代码，找出涉及的集合
      const migrationCode = require('fs').readFileSync(migration.path, 'utf8');
      const collectionMatches = migrationCode.match(/db\.collection\(['"]([^'"]+)['"]\)/g);
      
      if (!collectionMatches) {
        this.logger.debug('迁移没有涉及任何集合，跳过备份', { name: migration.name });
        return false;
      }
      
      // 提取集合名称
      const collections = [...new Set(
        collectionMatches.map(match => {
          const nameMatch = match.match(/db\.collection\(['"]([^'"]+)['"]\)/);
          return nameMatch ? nameMatch[1] : null;
        }).filter(Boolean)
      )];
      
      if (collections.length === 0) {
        this.logger.debug('未找到涉及的集合，跳过备份', { name: migration.name });
        return false;
      }
      
      // 为每个集合创建备份
      for (const collection of collections) {
        const backupName = `${collection}_backup_${new Date().getTime()}`;
        
        // 检查集合是否存在
        const collExists = await mongoose.connection.db
          .listCollections({ name: collection })
          .hasNext();
        
        if (!collExists) {
          this.logger.debug('集合不存在，跳过备份', { collection });
          continue;
        }
        
        // 创建备份集合
        await mongoose.connection.db.createCollection(backupName);
        
        // 复制数据
        const cursor = mongoose.connection.db.collection(collection).find({});
        
        // 分批处理数据
        const batchSize = 1000;
        let batch = [];
        
        while (await cursor.hasNext()) {
          const doc = await cursor.next();
          batch.push(doc);
          
          if (batch.length >= batchSize) {
            if (batch.length > 0) {
              await mongoose.connection.db.collection(backupName).insertMany(batch);
            }
            batch = [];
          }
        }
        
        // 插入剩余的数据
        if (batch.length > 0) {
          await mongoose.connection.db.collection(backupName).insertMany(batch);
        }
        
        // 记录备份信息
        await mongoose.connection.db.collection('migration_backups').insertOne({
          migrationName: migration.name,
          originalCollection: collection,
          backupCollection: backupName,
          timestamp: new Date()
        });
        
        this.logger.info('创建集合备份', { 
          collection, 
          backup: backupName,
          migration: migration.name
        });
      }
      
      return true;
    } catch (error) {
      this.logger.error('创建集合备份失败', { name: migration.name, error });
      // 不抛出异常，允许继续进行迁移
      return false;
    }
  }

  /**
   * 记录迁移应用
   */
  async _recordMigration(name, result) {
    try {
      await mongoose.connection.db.collection(this.config.migrationCollection).insertOne({
        name,
        appliedAt: new Date(),
        result: result || { success: true }
      });
      
      return true;
    } catch (error) {
      this.logger.error('记录迁移应用失败', { name, error });
      throw error;
    }
  }

  /**
   * 回滚最近的迁移
   */
  async rollbackLastMigration() {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      // 加载已应用的迁移
      await this._loadAppliedMigrations();
      
      if (this.appliedMigrations.length === 0) {
        this.logger.info('没有已应用的迁移可回滚');
        return false;
      }
      
      // 获取最近的迁移
      const lastMigration = this.appliedMigrations[0];
      
      // 加载迁移文件
      const migrationPath = path.join(this.config.migrationsDir, `${lastMigration.name}.js`);
      
      try {
        const migration = require(migrationPath);
        
        if (typeof migration.down !== 'function') {
          throw new Error('迁移文件不包含down方法');
        }
        
        this.logger.info('回滚迁移', { name: lastMigration.name });
        
        // 执行回滚
        const result = await migration.down(mongoose.connection.db);
        
        // 删除迁移记录
        await mongoose.connection.db.collection(this.config.migrationCollection).deleteOne({
          name: lastMigration.name
        });
        
        // 重新加载迁移
        await this._loadAppliedMigrations();
        await this._loadPendingMigrations();
        
        this.logger.info('回滚迁移成功', { name: lastMigration.name });
        this.emit('migrationRolledBack', { name: lastMigration.name, result });
        
        return { name: lastMigration.name, result };
      } catch (error) {
        this.logger.error('回滚迁移失败', { name: lastMigration.name, error });
        throw error;
      }
    } catch (error) {
      this.logger.error('回滚最近的迁移失败', { error });
      throw error;
    }
  }

  /**
   * 回滚到特定迁移
   */
  async rollbackToMigration(targetName) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      // 加载已应用的迁移
      await this._loadAppliedMigrations();
      
      if (this.appliedMigrations.length === 0) {
        this.logger.info('没有已应用的迁移可回滚');
        return false;
      }
      
      // 找到目标迁移的索引
      const targetIndex = this.appliedMigrations.findIndex(m => m.name === targetName);
      
      if (targetIndex === -1) {
        throw new Error(`找不到迁移 ${targetName}`);
      }
      
      // 获取需要回滚的迁移
      const migrationsToRollback = this.appliedMigrations.slice(0, targetIndex);
      
      this.logger.info('回滚到迁移', { 
        target: targetName, 
        count: migrationsToRollback.length 
      });
      
      const results = {
        success: [],
        failed: []
      };
      
      // 逐个回滚迁移
      for (const migration of migrationsToRollback) {
        try {
          const migrationPath = path.join(this.config.migrationsDir, `${migration.name}.js`);
          const migrationModule = require(migrationPath);
          
          if (typeof migrationModule.down !== 'function') {
            throw new Error('迁移文件不包含down方法');
          }
          
          this.logger.info('回滚迁移', { name: migration.name });
          
          // 执行回滚
          const result = await migrationModule.down(mongoose.connection.db);
          
          // 删除迁移记录
          await mongoose.connection.db.collection(this.config.migrationCollection).deleteOne({
            name: migration.name
          });
          
          results.success.push(migration.name);
          this.emit('migrationRolledBack', { name: migration.name, result });
        } catch (error) {
          this.logger.error('回滚迁移失败', { name: migration.name, error });
          results.failed.push({ name: migration.name, error: error.message });
          
          // 如果配置了在出错时停止
          if (this.config.stopOnError) {
            break;
          }
        }
      }
      
      // 重新加载迁移
      await this._loadAppliedMigrations();
      await this._loadPendingMigrations();
      
      this.logger.info('回滚到迁移完成', { 
        target: targetName,
        success: results.success.length, 
        failed: results.failed.length 
      });
      
      return {
        rolledBack: results.success.length,
        failed: results.failed.length,
        results
      };
    } catch (error) {
      this.logger.error('回滚到迁移失败', { target: targetName, error });
      throw error;
    }
  }

  /**
   * 从模式变更生成迁移
   */
  async generateMigrationFromChanges(modelName, changes, description) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      this.logger.info('从模式变更生成迁移', { modelName });
      
      // 准备变更对象
      const migrationChanges = {
        ...changes,
        collection: modelName.toLowerCase()
      };
      
      // 创建迁移
      const migrationName = `update_${modelName.toLowerCase()}`;
      const migrationDesc = description || `更新${modelName}模式`;
      
      return await this.createMigration(migrationName, migrationDesc, migrationChanges);
    } catch (error) {
      this.logger.error('从模式变更生成迁移失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 获取服务状态
   */
  getStatus() {
    return {
      service: 'MigrationManagerService',
      initialized: this.initialized,
      pendingMigrations: this.pendingMigrations.map(m => m.name),
      appliedMigrations: this.appliedMigrations.map(m => m.name),
      config: this.config
    };
  }
}

module.exports = MigrationManagerService; 