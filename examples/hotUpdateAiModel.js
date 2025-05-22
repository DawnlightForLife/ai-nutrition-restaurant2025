/**
 * 模型热更新示例 - 演示如何动态更新AI推荐模型
 * 
 * 使用方法:
 * 1. 确保服务器运行中
 * 2. 运行: node examples/hotUpdateAiModel.js
 */

const axios = require('axios');
const fs = require('fs');
const path = require('path');

// 配置
const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:5000/api';
const AUTH_TOKEN = process.env.AUTH_TOKEN || 'your_admin_token_here';
const TARGET_MODEL = 'aiRecommendation';

/**
 * 获取模型当前版本
 */
async function getModelVersion() {
  try {
    const response = await axios.get(
      `${API_BASE_URL}/model-hot-update/models/${TARGET_MODEL}/version`,
      {
        headers: {
          'Authorization': `Bearer ${AUTH_TOKEN}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    return response.data.data.version;
  } catch (error) {
    console.error('获取模型版本失败:', error.response ? error.response.data : error.message);
    return null;
  }
}

/**
 * 更新AI推荐模型
 */
async function updateAiRecommendationModel() {
  try {
    // 获取当前版本
    const currentVersion = await getModelVersion();
    console.log(`当前AI推荐模型版本: ${currentVersion || '未知'}`);
    
    // 新的模型定义（带有更新的推荐算法）
    const newModelDefinition = {
      schema: {
        userId: {
          type: String,
          required: true,
          ref: 'User',
          description: '用户ID'
        },
        recommendationType: {
          type: String,
          required: true,
          enum: ['MENU', 'DISH', 'RESTAURANT', 'NUTRITION'],
          description: '推荐类型'
        },
        items: [{
          itemId: {
            type: String,
            required: true,
            description: '推荐项目ID'
          },
          itemType: {
            type: String,
            required: true,
            enum: ['DISH', 'MENU', 'RESTAURANT'],
            description: '项目类型'
          },
          score: {
            type: Number,
            required: true,
            min: 0,
            max: 100,
            description: '推荐得分'
          },
          reasons: [{
            type: String,
            description: '推荐原因'
          }],
          metadata: {
            type: Object,
            description: '额外元数据'
          }
        }],
        algorithm: {
          type: String,
          required: true,
          default: 'hybrid_v2',
          description: '使用的推荐算法'
        },
        context: {
          type: Object,
          description: '推荐上下文信息'
        },
        nutritionSummary: {
          calories: Number,
          protein: Number,
          carbs: Number,
          fat: Number
        },
        feedback: {
          liked: Boolean,
          rating: {
            type: Number,
            min: 1,
            max: 5
          },
          comments: String
        },
        createdAt: {
          type: Date,
          default: Date.now
        }
      },
      // 带有更新算法的静态方法
      statics: {
        // 新版本的推荐算法
        async generateRecommendations(userId, options = {}) {
          console.log(`使用新的混合推荐算法 v2 为用户 ${userId} 生成推荐`);
          
          // 从用户模型获取用户信息
          const User = this.model('User');
          const user = await User.findById(userId);
          
          if (!user) {
            throw new Error('用户不存在');
          }
          
          // 获取用户的营养档案
          const NutritionProfile = this.model('nutritionProfile');
          const profile = await NutritionProfile.findOne({ userId });
          
          // 新的推荐逻辑 - 增加个性化权重和多样化
          const recommendationType = options.type || 'MENU';
          const limit = options.limit || 10;
          
          // 使用更新的算法逻辑
          const recommendations = await this._hybridRecommendationAlgorithmV2(
            user,
            profile,
            recommendationType,
            limit
          );
          
          // 创建推荐记录
          const recommendation = new this({
            userId,
            recommendationType,
            items: recommendations.map(item => ({
              itemId: item.id,
              itemType: item.type,
              score: item.score,
              reasons: item.reasons
            })),
            algorithm: 'hybrid_v2',
            context: options.context || {},
            nutritionSummary: recommendations.nutritionSummary || {}
          });
          
          await recommendation.save();
          return recommendation;
        },
        
        // 新版本的混合推荐算法
        async _hybridRecommendationAlgorithmV2(user, profile, type, limit) {
          console.log('执行混合推荐算法 v2');
          
          // 这里是示例逻辑，实际实现会更加复杂
          const collaborativeWeight = 0.4;  // 协同过滤权重
          const contentWeight = 0.3;        // 内容过滤权重
          const contextWeight = 0.2;        // 上下文感知权重
          const randomWeight = 0.1;         // 随机探索权重
          
          // 获取各种推荐结果
          const collaborativeResults = await this._getCollaborativeRecommendations(user, type, limit);
          const contentResults = await this._getContentBasedRecommendations(user, profile, type, limit);
          const contextResults = await this._getContextAwareRecommendations(user, type, limit);
          const randomResults = await this._getRandomRecommendations(type, limit);
          
          // 合并结果，应用新的权重系统
          const mergedResults = this._mergeRecommendationsWithDiversity(
            collaborativeResults, contentResults, contextResults, randomResults,
            collaborativeWeight, contentWeight, contextWeight, randomWeight
          );
          
          // 应用新的多样性增强算法
          const diverseResults = this._enhanceDiversity(mergedResults, type);
          
          // 应用营养平衡算法
          return this._applyNutritionBalancing(diverseResults, profile);
        },
        
        // 新方法：合并推荐并增加多样性
        _mergeRecommendationsWithDiversity(collaborative, content, context, random, w1, w2, w3, w4) {
          // 示例实现
          const allItems = new Map();
          
          // 合并所有来源的推荐，使用权重
          [...collaborative, ...content, ...context, ...random].forEach(item => {
            if (allItems.has(item.id)) {
              const existing = allItems.get(item.id);
              // 根据来源应用权重
              let weightedScore = existing.score;
              if (collaborative.find(i => i.id === item.id)) {
                weightedScore += item.score * w1;
              }
              if (content.find(i => i.id === item.id)) {
                weightedScore += item.score * w2;
              }
              if (context.find(i => i.id === item.id)) {
                weightedScore += item.score * w3;
              }
              if (random.find(i => i.id === item.id)) {
                weightedScore += item.score * w4;
              }
              
              existing.score = weightedScore;
              existing.reasons = [...new Set([...existing.reasons, ...item.reasons])];
            } else {
              allItems.set(item.id, { ...item });
            }
          });
          
          // 转换回数组并排序
          return Array.from(allItems.values())
            .sort((a, b) => b.score - a.score);
        },
        
        // 新方法：增强多样性
        _enhanceDiversity(recommendations, type) {
          // 示例实现
          const categories = new Map();
          const result = [];
          
          // 分析类别分布
          recommendations.forEach(item => {
            const category = item.category || 'unknown';
            if (!categories.has(category)) {
              categories.set(category, []);
            }
            categories.get(category).push(item);
          });
          
          // 确保结果有不同类别的项目
          let index = 0;
          while (result.length < recommendations.length) {
            for (const [category, items] of categories.entries()) {
              if (index < items.length) {
                result.push(items[index]);
                if (result.length >= recommendations.length) break;
              }
            }
            index++;
          }
          
          return result;
        },
        
        // 新方法：营养平衡
        _applyNutritionBalancing(recommendations, profile) {
          // 示例实现 - 根据用户营养档案调整推荐
          if (!profile) return recommendations;
          
          // 计算总体营养摘要
          const nutritionSummary = {
            calories: 0,
            protein: 0,
            carbs: 0,
            fat: 0
          };
          
          // 调整推荐结果，使其更符合用户的营养需求
          const balanced = recommendations.map(item => {
            if (item.nutritionInfo) {
              nutritionSummary.calories += item.nutritionInfo.calories || 0;
              nutritionSummary.protein += item.nutritionInfo.protein || 0;
              nutritionSummary.carbs += item.nutritionInfo.carbs || 0;
              nutritionSummary.fat += item.nutritionInfo.fat || 0;
            }
            return item;
          });
          
          // 添加营养摘要到结果
          balanced.nutritionSummary = nutritionSummary;
          
          return balanced;
        }
      },
      // 实例方法
      methods: {
        // 添加反馈信息的更新方法
        async addFeedback(feedback) {
          this.feedback = {
            ...this.feedback,
            ...feedback,
            updatedAt: new Date()
          };
          
          return await this.save();
        }
      },
      options: {
        timestamps: true,
        collection: 'ai_recommendations'
      }
    };
    
    // 调用API更新模型
    const response = await axios.post(
      `${API_BASE_URL}/model-hot-update/models/${TARGET_MODEL}`,
      newModelDefinition,
      {
        headers: {
          'Authorization': `Bearer ${AUTH_TOKEN}`,
          'Content-Type': 'application/json'
        },
        params: {
          force: true  // 强制所有节点更新
        }
      }
    );
    
    // 输出更新结果
    if (response.data.success) {
      console.log(`\n✅ AI推荐模型已成功更新!`);
      console.log(`- 旧版本: v${response.data.data.oldVersion}`);
      console.log(`- 新版本: v${response.data.data.newVersion}`);
      console.log(`- 更新内容: 增强了推荐算法，添加了多样性和营养平衡处理`);
    } else {
      console.error('更新失败:', response.data);
    }
  } catch (error) {
    console.error('更新AI推荐模型失败:', error.response ? error.response.data : error.message);
  }
}

// 运行示例
console.log('🚀 开始执行AI推荐模型热更新示例...');
updateAiRecommendationModel().then(() => {
  console.log('\n📝 说明：');
  console.log('- 模型已在不重启服务的情况下完成更新');
  console.log('- 新的推荐算法已立即生效');
  console.log('- 该更新适用于所有服务节点（force=true）');
  console.log('\n您现在可以测试新的推荐功能!');
}); 