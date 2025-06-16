# AI Nutrition Service

智能营养推荐微服务，基于Python FastAPI构建，提供科学的营养计算和个性化推荐功能。

## 功能特性

- 🧠 科学营养计算（Mifflin-St Jeor方程）
- 🍽️ 个性化饮食推荐
- 📊 营养目标设定
- 🔄 用户反馈收集
- 🏥 健康状况考虑
- 🚫 过敏原避免

## 架构设计

```
ai_service/
├── main.py                    # FastAPI应用主文件
├── requirements.txt           # Python依赖
├── Dockerfile                # Docker容器配置
├── services/                  # 服务层
│   ├── __init__.py
│   ├── nutrition_calculator.py  # 营养计算核心
│   └── recommendation_engine.py # 推荐引擎（未来扩展）
├── utils/                     # 工具类
│   ├── __init__.py
│   └── validators.py         # 数据验证
└── config/                   # 配置文件
    ├── __init__.py
    └── settings.py          # 应用配置
```

## API 端点

### 健康检查
```
GET /api/v1/health
```

### 生成营养推荐
```
POST /api/v1/nutrition/recommendations
```

请求体：
```json
{
  "gender": "male|female",
  "age": 30,
  "height": 175.0,
  "weight": 70.0,
  "activity_level": "moderate",
  "health_goal": "maintain",
  "dietary_restrictions": ["素食"],
  "health_conditions": ["糖尿病"],
  "allergies": ["花生"]
}
```

响应：
```json
{
  "targets": {
    "calories": 2200.0,
    "protein": 110.0,
    "carbs": 275.0,
    "fat": 73.3
  },
  "recommendations": [
    "建议每日摄入2200卡路里",
    "增加高质量蛋白质摄入",
    "控制碳水化合物摄入量"
  ],
  "meal_suggestions": [
    "早餐：燕麦粥配坚果",
    "午餐：烤鸡胸肉配蔬菜",
    "晚餐：鱼类配糙米"
  ],
  "metadata": {
    "calculation_method": "scientific",
    "model_version": "1.0.0",
    "generated_at": "2025-01-16T10:30:00"
  }
}
```

### 提交反馈
```
POST /api/v1/nutrition/recommendations/{recommendation_id}/feedback
```

## 营养计算算法

### 基础代谢率 (BMR)
使用Mifflin-St Jeor方程：
- 男性：BMR = 10 × 体重(kg) + 6.25 × 身高(cm) - 5 × 年龄 + 5
- 女性：BMR = 10 × 体重(kg) + 6.25 × 身高(cm) - 5 × 年龄 - 161

### 总能量消耗 (TDEE)
```python
activity_multipliers = {
    'sedentary': 1.2,     # 久坐不动
    'light': 1.375,      # 轻度活动
    'moderate': 1.55,    # 中度活动  
    'active': 1.725,     # 活跃
    'very_active': 1.9   # 非常活跃
}
```

### 宏营养素分配
根据健康目标调整：
- 减重：蛋白质30%，脂肪35%，碳水35%
- 增重：蛋白质25%，脂肪30%，碳水45%
- 维持：蛋白质25%，脂肪30%，碳水45%

## 运行方式

### 本地开发
```bash
cd ai_service
pip install -r requirements.txt
python main.py
```

### Docker部署
```bash
docker build -t ai-nutrition-service .
docker run -p 8001:8001 ai-nutrition-service
```

## 配置说明

- 服务端口：8001
- 日志级别：INFO
- CORS：允许所有来源（开发环境）

## 扩展计划

1. **DeepSeek模型集成**：用于更智能的推荐生成
2. **食材数据库**：支持具体食物推荐
3. **机器学习**：基于用户反馈优化推荐
4. **多语言支持**：国际化功能
5. **缓存机制**：提高响应速度

## 监控和日志

- 使用loguru进行结构化日志记录
- 记录所有API请求和错误
- 支持生产环境监控集成

## 安全考虑

- 输入数据验证
- 错误信息脱敏
- 健康状况数据保护
- API访问控制（计划中）