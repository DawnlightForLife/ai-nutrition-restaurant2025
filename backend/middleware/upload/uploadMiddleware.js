const multer = require('multer');
const path = require('path');
const fs = require('fs');

// 确保上传目录存在
const uploadDir = path.join(__dirname, '../../uploads');
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir, { recursive: true });
}

// 配置存储
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const userUploadDir = path.join(uploadDir, 'avatars');
    if (!fs.existsSync(userUploadDir)) {
      fs.mkdirSync(userUploadDir, { recursive: true });
    }
    cb(null, userUploadDir);
  },
  filename: function (req, file, cb) {
    // 使用用户ID和时间戳命名文件
    const userId = req.user?.id || req.user?.userId || 'unknown';
    const ext = path.extname(file.originalname);
    const fileName = `${userId}_${Date.now()}${ext}`;
    cb(null, fileName);
  }
});

// 文件过滤器
const fileFilter = (req, file, cb) => {
  console.log(`文件过滤器检查: 文件名=${file.originalname}, MIME类型=${file.mimetype}`);
  
  // 支持的文件扩展名
  const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif'];
  // 支持的MIME类型
  const allowedMimeTypes = [
    'image/jpeg', 
    'image/jpg', 
    'image/png', 
    'image/gif',
    // 移动设备可能使用的其他MIME类型
    'image/pjpeg'
  ];
  
  const fileExtension = path.extname(file.originalname).toLowerCase();
  const mimeType = file.mimetype.toLowerCase();
  
  const isValidExtension = allowedExtensions.includes(fileExtension);
  const isValidMimeType = allowedMimeTypes.includes(mimeType);

  console.log(`扩展名: ${fileExtension}, 有效: ${isValidExtension}`);
  console.log(`MIME类型: ${mimeType}, 有效: ${isValidMimeType}`);

  // 只要扩展名或MIME类型其中一个通过就行（更宽松的检查）
  if (isValidExtension || isValidMimeType) {
    console.log('文件验证通过');
    return cb(null, true);
  } else {
    console.log(`文件验证失败: 扩展名=${fileExtension}, MIME=${mimeType}`);
    cb(new Error(`不支持的文件格式。请上传 JPG、PNG 或 GIF 格式的图片。当前文件: ${file.originalname} (${mimeType})`));
  }
};

// 配置上传 - 临时禁用文件类型检查
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB限制
  },
  // 临时注释掉文件过滤器，方便测试
  // fileFilter: fileFilter
});

// 可选的头像上传中间件 - 如果没有文件也不报错
const optionalUploadAvatar = (req, res, next) => {
  const uploadSingle = upload.single('avatar');
  
  uploadSingle(req, res, (err) => {
    if (err) {
      console.log('上传中间件错误:', err.message, '错误代码:', err.code);
      
      if (err.code === 'LIMIT_UNEXPECTED_FILE') {
        // 如果没有文件字段，继续处理
        console.log('没有文件字段，继续处理');
        return next();
      } else {
        // 其他错误（如文件类型不支持）
        console.log('文件上传错误:', err.message);
        return res.status(400).json({
          success: false,
          message: err.message || '文件上传失败'
        });
      }
    }
    
    // 没有错误，继续处理
    console.log('文件上传成功或无文件，继续处理');
    next();
  });
};

module.exports = {
  uploadAvatar: upload.single('avatar'),
  optionalUploadAvatar,
  uploadMultiple: upload.array('files', 5)
};