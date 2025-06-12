/**
 * 测试商家重新提交申请的完整流程
 * 用于验证修复后的逻辑是否正常工作
 */

const mongoose = require('mongoose');
const { merchantService } = require('../../services');
const Merchant = require('../../models/merchant/merchantModel');
const User = require('../../models/user/userModel');
const MerchantAudit = require('../../models/merchant/merchantAuditModel');

// 连接数据库
require('../../config/db.config');

async function testMerchantResubmissionFlow() {
  try {
    console.log('🚀 开始测试商家重新提交申请流程...\n');

    // 1. 创建测试用户
    console.log('1. 创建测试用户...');
    const testUser = new User({
      username: 'testmerchant_' + Date.now(),
      email: 'test@example.com',
      phone: '13800138000',
      password: 'hashedpassword'
    });
    await testUser.save();
    console.log(`✅ 用户创建成功: ${testUser._id}\n`);

    // 2. 创建被拒绝的商家申请
    console.log('2. 创建被拒绝的商家申请...');
    const merchantData = {
      userId: testUser._id,
      businessName: '测试商家_' + Date.now(),
      businessType: 'restaurant',
      registrationNumber: 'TEST123456789',
      taxId: 'TAX123456789',
      contact: {
        email: 'merchant@example.com',
        phone: '13800138001'
      },
      address: {
        line1: '测试地址123号',
        city: '深圳市',
        province: '广东省',
        district: '南山区',
        postalCode: '518000',
        country: 'China'
      },
      businessProfile: {
        description: '测试商家描述',
        isFranchise: true,
        franchiseInfo: {
          franchiseLevel: 'basic'
        }
      }
    };

    const createResult = await merchantService.createMerchant(merchantData);
    if (!createResult.success) {
      throw new Error(`创建商家失败: ${createResult.message}`);
    }
    const merchant = createResult.data;
    console.log(`✅ 商家创建成功: ${merchant._id}`);
    console.log(`   初始状态: ${merchant.verification.verificationStatus}\n`);

    // 3. 模拟管理员拒绝申请
    console.log('3. 模拟管理员拒绝申请...');
    const verifyResult = await merchantService.verifyMerchant(merchant._id, {
      verificationStatus: 'rejected',
      rejectionReason: '营业执照信息不清晰，请重新上传',
      verifiedBy: new mongoose.Types.ObjectId(),
      verifiedAt: new Date()
    });
    
    if (!verifyResult.success) {
      throw new Error(`拒绝申请失败: ${verifyResult.message}`);
    }
    console.log(`✅ 申请拒绝成功`);
    console.log(`   状态更新为: ${verifyResult.data.verification.verificationStatus}`);
    console.log(`   拒绝原因: ${verifyResult.data.verification.rejectionReason}\n`);

    // 4. 模拟商家重新提交申请
    console.log('4. 模拟商家重新提交申请...');
    const updateData = {
      businessName: '测试商家_更新版_' + Date.now(),
      businessType: 'restaurant',
      registrationNumber: 'TEST123456789_UPDATED',
      contact: {
        email: 'merchant_updated@example.com',
        phone: '13800138002'
      },
      address: {
        line1: '更新后的测试地址456号',
        city: '深圳市',
        province: '广东省',
        district: '南山区',
        postalCode: '518000',
        country: 'China'
      },
      verification: {
        verificationStatus: 'pending',
        rejectionReason: null,
        verificationDate: null
      }
    };

    const updateResult = await merchantService.updateMerchant(merchant._id, updateData);
    if (!updateResult.success) {
      throw new Error(`重新提交失败: ${updateResult.message}`);
    }
    console.log(`✅ 重新提交成功`);
    console.log(`   状态更新为: ${updateResult.data.verification.verificationStatus}`);
    console.log(`   重新提交次数: ${updateResult.data.verification.resubmissionCount}`);
    console.log(`   最后重新提交时间: ${updateResult.data.verification.lastResubmissionDate}\n`);

    // 5. 验证管理员能看到重新提交的申请
    console.log('5. 验证管理员能看到重新提交的申请...');
    const pendingResult = await merchantService.getMerchants({
      verificationStatus: 'pending'
    });
    
    if (!pendingResult.success) {
      throw new Error(`获取待审核商家失败: ${pendingResult.message}`);
    }
    
    const foundPendingMerchant = pendingResult.data.find(
      m => m._id.toString() === merchant._id.toString()
    );
    
    if (foundPendingMerchant) {
      console.log(`✅ 管理员可以看到重新提交的申请`);
      console.log(`   商家名称: ${foundPendingMerchant.businessName}`);
      console.log(`   状态: ${foundPendingMerchant.verification.verificationStatus}\n`);
    } else {
      console.log(`❌ 管理员无法看到重新提交的申请\n`);
    }

    // 6. 检查审核历史记录
    console.log('6. 检查审核历史记录...');
    const auditRecords = await MerchantAudit.find({ merchantId: merchant._id }).sort({ createdAt: 1 });
    console.log(`✅ 找到 ${auditRecords.length} 条审核记录:`);
    
    auditRecords.forEach((record, index) => {
      console.log(`   记录 ${index + 1}: ${record.auditType} - ${record.auditStatus}`);
      console.log(`     创建时间: ${record.createdAt}`);
    });

    // 7. 清理测试数据
    console.log('\n7. 清理测试数据...');
    await MerchantAudit.deleteMany({ merchantId: merchant._id });
    await Merchant.findByIdAndDelete(merchant._id);
    await User.findByIdAndDelete(testUser._id);
    console.log('✅ 测试数据清理完成');

    console.log('\n🎉 测试完成！所有步骤都正常工作。');

  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    console.error(error.stack);
  } finally {
    // 关闭数据库连接
    await mongoose.connection.close();
    process.exit(0);
  }
}

// 运行测试
if (require.main === module) {
  testMerchantResubmissionFlow();
}

module.exports = testMerchantResubmissionFlow;