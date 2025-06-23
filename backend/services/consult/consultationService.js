const ConsultationModel = require('../../models/consult/consultationModel');
const { AppError } = require('../../middleware/core/errorHandlingMiddleware');

module.exports = {
  /**
   * 创建咨询
   * @param {Object} consultationData - 咨询数据
   * @returns {Promise<Object>} 创建的咨询对象
   */
  async createConsultation(consultationData) {
    try {
      const consultation = new ConsultationModel(consultationData);
      return await consultation.save();
    } catch (error) {
      throw new AppError('创建咨询失败', 400, error);
    }
  },

  /**
   * 获取咨询列表
   * @param {Object} query - 查询条件
   * @returns {Promise<Array>} 咨询列表
   */
  async getConsultationList(query) {
    try {
      const { page = 1, limit = 20, ...filters } = query;
      const skip = (page - 1) * limit;
      
      return await ConsultationModel.find(filters)
        .populate('userId', 'username avatar phone')
        .populate('nutritionistId', 'name avatar specialty')
        .sort('-createdAt')
        .skip(skip)
        .limit(limit);
    } catch (error) {
      throw new AppError('获取咨询列表失败', 400, error);
    }
  },

  /**
   * 根据营养师ID获取咨询列表
   * @param {String} nutritionistId - 营养师ID
   * @param {Object} options - 查询选项
   * @returns {Promise<Array>} 咨询列表
   */
  async getConsultationsByNutritionist(nutritionistId, options = {}) {
    try {
      const { 
        status, 
        startDate, 
        endDate, 
        page = 1, 
        limit = 20 
      } = options;
      
      const query = { nutritionistId };
      
      if (status) {
        if (Array.isArray(status)) {
          query.status = { $in: status };
        } else {
          query.status = status;
        }
      }
      
      if (startDate || endDate) {
        query.createdAt = {};
        if (startDate) query.createdAt.$gte = startDate;
        if (endDate) query.createdAt.$lte = endDate;
      }
      
      const skip = (page - 1) * limit;
      
      return await ConsultationModel.find(query)
        .populate('userId', 'username avatar phone')
        .sort('-createdAt')
        .skip(skip)
        .limit(limit);
    } catch (error) {
      throw new AppError('获取营养师咨询列表失败', 400, error);
    }
  },

  /**
   * 获取即将进行的咨询
   * @param {String} nutritionistId - 营养师ID
   * @param {Number} limit - 限制数量
   * @returns {Promise<Array>} 咨询列表
   */
  async getUpcomingConsultations(nutritionistId, limit = 5) {
    try {
      const now = new Date();
      
      return await ConsultationModel.find({
        nutritionistId,
        status: { $in: ['pending', 'active'] },
        appointmentTime: { $gte: now }
      })
        .populate('userId', 'username avatar')
        .sort('appointmentTime')
        .limit(limit);
    } catch (error) {
      throw new AppError('获取即将进行的咨询失败', 400, error);
    }
  },

  /**
   * 根据ID获取咨询
   * @param {String} consultationId - 咨询ID
   * @returns {Promise<Object>} 咨询对象
   */
  async getConsultationById(consultationId) {
    try {
      const consultation = await ConsultationModel.findById(consultationId)
        .populate('userId', 'username avatar phone email')
        .populate('nutritionistId', 'name avatar specialty rating');
        
      if (!consultation) {
        throw new AppError('咨询不存在', 404);
      }
      
      return consultation;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('无效的咨询ID', 400);
      }
      throw error;
    }
  },

  /**
   * 更新咨询
   * @param {String} consultationId - 咨询ID
   * @param {Object} updateData - 更新数据
   * @returns {Promise<Object>} 更新后的咨询对象
   */
  async updateConsultation(consultationId, updateData) {
    try {
      const consultation = await ConsultationModel.findByIdAndUpdate(
        consultationId,
        updateData,
        { new: true, runValidators: true }
      )
        .populate('userId', 'username avatar phone')
        .populate('nutritionistId', 'name avatar specialty');
        
      if (!consultation) {
        throw new AppError('咨询不存在', 404);
      }
      
      return consultation;
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('无效的咨询ID', 400);
      }
      throw error;
    }
  },

  /**
   * 删除咨询
   * @param {String} consultationId - 咨询ID
   * @returns {Promise<Object>} 删除结果
   */
  async deleteConsultation(consultationId) {
    try {
      const consultation = await ConsultationModel.findByIdAndDelete(consultationId);
      
      if (!consultation) {
        throw new AppError('咨询不存在', 404);
      }
      
      return { success: true, message: '咨询已删除' };
    } catch (error) {
      if (error.name === 'CastError') {
        throw new AppError('无效的咨询ID', 400);
      }
      throw error;
    }
  }
};