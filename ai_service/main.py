from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Optional
from datetime import datetime
import uvicorn
import logging

# 配置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(
    title="AI营养推荐服务",
    description="基于DeepSeek的个性化营养推荐API服务",
    version="1.0.0"
)

# CORS配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # 生产环境需要限制
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 数据模型
class NutritionProfileInput(BaseModel):
    user_id: str
    profile_name: str
    gender: str
    age_group: str
    height: float
    weight: float
    health_goals: List[str]
    dietary_preferences: List[str] = []
    medical_conditions: List[str] = []
    exercise_frequency: Optional[str] = None
    allergies: List[str] = []
    forbidden_ingredients: List[str] = []
    nutrition_preferences: List[str] = []
    special_status: List[str] = []

class MacroRatios(BaseModel):
    protein: float
    fat: float
    carbs: float

class NutritionTargets(BaseModel):
    daily_calories: float
    hydration_goal: float
    meal_frequency: int
    macro_ratios: MacroRatios
    vitamin_targets: Dict[str, float]
    mineral_targets: Dict[str, float]

class RecommendationExplanation(BaseModel):
    category: str
    field: str
    explanation: str
    reasoning: str

class AIRecommendationResponse(BaseModel):
    recommendation_id: str
    profile_id: str
    nutrition_targets: NutritionTargets
    explanations: List[RecommendationExplanation]
    confidence: float
    source: str = "mock"  # mock, deepseek, rule_based
    processing_time_ms: int
    created_at: datetime

@app.get("/")
def read_root():
    return {
        "service": "AI营养推荐服务",
        "version": "1.0.0",
        "status": "running",
        "endpoints": [
            "/api/v1/nutrition/recommendations",
            "/api/v1/health"
        ]
    }

@app.get("/api/v1/health")
async def health_check():
    """健康检查端点"""
    return {
        "status": "healthy",
        "service": "ai-nutrition",
        "timestamp": datetime.now().isoformat()
    }

@app.post("/api/v1/nutrition/recommendations", response_model=AIRecommendationResponse)
async def generate_nutrition_recommendation(profile: NutritionProfileInput):
    """生成个性化营养推荐"""
    start_time = datetime.now()
    
    try:
        # 导入营养计算服务
        from services.nutrition_calculator import NutritionCalculator
        
        calculator = NutritionCalculator()
        
        # 生成推荐
        nutrition_targets = calculator.calculate_nutrition_targets(profile.dict())
        explanations = calculator.generate_explanations(profile.dict(), nutrition_targets)
        
        # 计算处理时间
        processing_time = int((datetime.now() - start_time).total_seconds() * 1000)
        
        # 构建响应
        response = AIRecommendationResponse(
            recommendation_id=f"rec_{profile.user_id}_{int(datetime.now().timestamp())}",
            profile_id=profile.user_id,
            nutrition_targets=nutrition_targets,
            explanations=explanations,
            confidence=0.85,
            source="mock",
            processing_time_ms=processing_time,
            created_at=datetime.now()
        )
        
        logger.info(f"生成营养推荐成功: {response.recommendation_id}")
        return response
        
    except Exception as e:
        logger.error(f"生成营养推荐失败: {str(e)}")
        raise HTTPException(status_code=500, detail=f"推荐生成失败: {str(e)}")

@app.post("/api/v1/nutrition/recommendations/{recommendation_id}/feedback")
async def submit_feedback(
    recommendation_id: str,
    rating: int,
    comments: Optional[str] = None,
    is_accepted: bool = True,
    adjustments: Optional[Dict[str, float]] = None
):
    """提交用户反馈"""
    try:
        # TODO: 保存反馈到数据库
        logger.info(f"收到推荐反馈: {recommendation_id}, rating={rating}, accepted={is_accepted}")
        
        # 使用参数避免未使用警告
        feedback_data = {
            "recommendation_id": recommendation_id,
            "rating": rating,
            "comments": comments,
            "is_accepted": is_accepted,
            "adjustments": adjustments
        }
        
        return {
            "success": True,
            "message": "反馈已记录",
            "feedback": feedback_data
        }
    except Exception as e:
        logger.error(f"保存反馈失败: {str(e)}")
        raise HTTPException(status_code=500, detail=f"保存反馈失败: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
