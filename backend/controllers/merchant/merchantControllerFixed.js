/**
 * 在现有merchantController.js基础上新增的方法
 * 添加到原文件的exports中
 */

/**
 * 获取当前用户的商家申请
 * - 根据认证用户的ID查询商家信息
 * - 返回用户的商家申请列表（通常只有一个）
 */
exports.getCurrentUserMerchant = catchAsync(async (req, res) => {
  const userId = req.user.id;
  
  const result = await merchantService.getMerchantByUserId(userId);
  
  if (!result.success) {
    // 如果没有找到商家资料，返回空数组而不是错误
    if (result.message === '找不到此用户的商家资料') {
      return res.status(200).json({
        success: true,
        message: '该用户暂无商家申请',
        data: []
      });
    }
    
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  // 返回数组格式，保持与前端期望的一致性
  res.status(200).json({
    success: true,
    message: '获取用户商家申请成功',
    data: [result.data]  // 包装为数组
  });
});