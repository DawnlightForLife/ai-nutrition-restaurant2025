const NutritionProfile = require('../models/nutritionProfileModel');

class NutritionProfileService {
    constructor() {
        // 直接使用导入的Mongoose模型
        this.model = NutritionProfile;
    }

    async createProfile(profileData) {
        try {
            console.log('NutritionProfileService - profileData received:', JSON.stringify(profileData));
            
            // 创建一个新对象而不是修改原对象
            const formattedData = { ...profileData };
            
            // 将ownerId映射为user_id（模型中使用的字段名）
            if (profileData.ownerId && !profileData.user_id) {
                formattedData.user_id = profileData.ownerId;
                console.log(`映射字段: ownerId -> user_id: ${formattedData.user_id}`);
                // 移除ownerId字段，避免mongoose警告未知字段
                delete formattedData.ownerId;
            }
            
            // 处理嵌套对象 - 确保dietaryPreferences结构正确
            if (formattedData.dietaryPreferences) {
                // 确保dietaryPreferences作为对象存储，而不是数组或其他类型
                if (typeof formattedData.dietaryPreferences !== 'object' || Array.isArray(formattedData.dietaryPreferences)) {
                    console.warn('dietaryPreferences格式不正确，已转换为空对象');
                    formattedData.dietaryPreferences = {};
                }
            }
            
            console.log('格式化后的数据:', JSON.stringify(formattedData));
            
            try {
                const profile = new this.model(formattedData);
                return await profile.save();
            } catch (validationError) {
                console.error('营养档案验证或保存失败:', validationError);
                // 为调试添加更详细的错误信息
                if (validationError.name === 'ValidationError') {
                    console.error('验证错误字段:', Object.keys(validationError.errors).join(', '));
                }
                throw validationError;
            }
        } catch (error) {
            console.error('Error creating nutrition profile:', error);
            throw error;
        }
    }

    async getProfileById(profileId) {
        try {
            return await this.model.findById(profileId);
        } catch (error) {
            console.error('Error fetching nutrition profile:', error);
            throw error;
        }
    }

    async getProfilesByUserId(userId) {
        try {
            console.log(`获取用户(${userId})的营养档案列表`);
            // 查询条件使用user_id字段(后端模型使用的字段名)
            return await this.model.find({ user_id: userId }).sort({ createdAt: -1 });
        } catch (error) {
            console.error('Error fetching user nutrition profiles:', error);
            throw error;
        }
    }

    async updateProfile(profileId, updateData) {
        try {
            return await this.model.findByIdAndUpdate(
                profileId,
                { $set: updateData },
                { new: true, runValidators: true }
            );
        } catch (error) {
            console.error('Error updating nutrition profile:', error);
            throw error;
        }
    }

    async deleteProfile(profileId) {
        try {
            return await this.model.findByIdAndDelete(profileId);
        } catch (error) {
            console.error('Error deleting nutrition profile:', error);
            throw error;
        }
    }
}

// 创建单例实例
const nutritionProfileService = new NutritionProfileService();

module.exports = nutritionProfileService; 