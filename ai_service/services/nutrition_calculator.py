"""
营养计算核心服务
提供基于科学公式的营养推荐计算
"""
from typing import Dict, List, Any
import math


class NutritionCalculator:
    """营养计算器 - 提供科学的营养推荐计算"""
    
    def calculate_nutrition_targets(self, profile: Dict[str, Any]) -> Dict[str, Any]:
        """计算营养目标"""
        # 提取基本信息
        gender = profile.get('gender', 'other')
        age_group = profile.get('age_group', '26to35')
        height = profile.get('height', 170)
        weight = profile.get('weight', 60)
        health_goals = profile.get('health_goals', [])
        exercise_frequency = profile.get('exercise_frequency', 'moderate')
        
        # 计算年龄
        age = self._age_group_to_number(age_group)
        
        # 计算BMR（基础代谢率）
        bmr = self._calculate_bmr(gender, weight, height, age)
        
        # 计算TDEE（总日消耗）
        activity_level = self._map_exercise_to_activity(exercise_frequency)
        tdee = self._calculate_tdee(bmr, activity_level)
        
        # 根据健康目标调整热量
        daily_calories = self._adjust_calories_for_goals(tdee, health_goals)
        
        # 计算其他营养目标
        return {
            "daily_calories": round(daily_calories),
            "hydration_goal": self._calculate_hydration(weight, activity_level),
            "meal_frequency": self._recommend_meal_frequency(health_goals),
            "macro_ratios": self._calculate_macro_ratios(health_goals),
            "vitamin_targets": self._calculate_vitamin_targets(profile),
            "mineral_targets": self._calculate_mineral_targets(profile)
        }
    
    def generate_explanations(self, profile: Dict[str, Any], targets: Dict[str, Any]) -> List[Dict[str, str]]:
        """生成推荐解释"""
        explanations = []
        
        # 热量解释
        explanations.append({
            "category": "热量需求",
            "field": "daily_calories",
            "explanation": f"基于您的身高{profile.get('height')}cm、体重{profile.get('weight')}kg和活动水平，建议每日摄入{targets['daily_calories']}千卡",
            "reasoning": "使用Mifflin-St Jeor方程计算基础代谢率，结合活动水平和健康目标调整"
        })
        
        # 饮水解释
        explanations.append({
            "category": "水分需求",
            "field": "hydration_goal",
            "explanation": f"建议每日饮水{targets['hydration_goal']}毫升",
            "reasoning": "基于体重计算基础需求，并根据运动强度调整"
        })
        
        # 营养素比例解释
        macro = targets['macro_ratios']
        explanations.append({
            "category": "营养素比例",
            "field": "macro_ratios",
            "explanation": f"蛋白质{int(macro['protein']*100)}%、脂肪{int(macro['fat']*100)}%、碳水{int(macro['carbs']*100)}%",
            "reasoning": self._get_macro_reasoning(profile.get('health_goals', []))
        })
        
        return explanations
    
    def _age_group_to_number(self, age_group: str) -> int:
        """年龄组转换为数字"""
        mapping = {
            'under18': 16,
            '18to25': 22,
            '26to35': 30,
            '36to45': 40,
            '46to55': 50,
            '56to65': 60,
            'above65': 70
        }
        return mapping.get(age_group, 30)
    
    def _calculate_bmr(self, gender: str, weight: float, height: float, age: int) -> float:
        """计算基础代谢率 (Mifflin-St Jeor方程)"""
        if gender.lower() == 'male':
            return 10 * weight + 6.25 * height - 5 * age + 5
        else:
            return 10 * weight + 6.25 * height - 5 * age - 161
    
    def _map_exercise_to_activity(self, exercise_frequency: str) -> str:
        """运动频率映射到活动水平"""
        mapping = {
            'none': 'sedentary',
            'occasional': 'light',
            'regular': 'moderate',
            'intense': 'active',
            'frequent': 'very_active',
            'daily': 'very_active'
        }
        return mapping.get(exercise_frequency, 'moderate')
    
    def _calculate_tdee(self, bmr: float, activity_level: str) -> float:
        """计算总日消耗 (TDEE)"""
        multipliers = {
            'sedentary': 1.2,
            'light': 1.375,
            'moderate': 1.55,
            'active': 1.725,
            'very_active': 1.9
        }
        return bmr * multipliers.get(activity_level, 1.55)
    
    def _adjust_calories_for_goals(self, tdee: float, health_goals: List[str]) -> float:
        """根据健康目标调整热量"""
        if 'weight_loss' in health_goals or 'fat_loss' in health_goals:
            return tdee * 0.85  # 减少15%
        elif 'weight_gain' in health_goals or 'muscle_gain' in health_goals:
            return tdee * 1.15  # 增加15%
        else:
            return tdee
    
    def _calculate_hydration(self, weight: float, activity_level: str) -> float:
        """计算饮水需求"""
        base = weight * 35  # 基础需求：体重(kg) × 35ml
        
        # 根据活动水平调整
        if activity_level in ['active', 'very_active']:
            base *= 1.2  # 高强度运动增加20%
        
        return round(max(1500, min(4000, base)))  # 限制在1500-4000ml之间
    
    def _recommend_meal_frequency(self, health_goals: List[str]) -> int:
        """推荐用餐频次"""
        if 'weight_loss' in health_goals or 'fat_loss' in health_goals:
            return 5  # 少食多餐
        elif 'muscle_gain' in health_goals:
            return 6  # 频繁进食
        else:
            return 3  # 常规三餐
    
    def _calculate_macro_ratios(self, health_goals: List[str]) -> Dict[str, float]:
        """计算宏量营养素比例"""
        if 'weight_loss' in health_goals or 'fat_loss' in health_goals:
            return {'protein': 0.30, 'fat': 0.25, 'carbs': 0.45}
        elif 'muscle_gain' in health_goals:
            return {'protein': 0.35, 'fat': 0.25, 'carbs': 0.40}
        elif 'endurance' in health_goals:
            return {'protein': 0.20, 'fat': 0.25, 'carbs': 0.55}
        else:
            return {'protein': 0.25, 'fat': 0.30, 'carbs': 0.45}
    
    def _calculate_vitamin_targets(self, profile: Dict[str, Any]) -> Dict[str, float]:
        """计算维生素需求（单位：mg或μg）"""
        age = self._age_group_to_number(profile.get('age_group', '26to35'))
        is_male = profile.get('gender', 'other').lower() == 'male'
        
        targets = {
            'vitaminA': 900 if is_male else 700,  # μg RAE
            'vitaminC': 90 if is_male else 75,    # mg
            'vitaminD': 800 if age > 70 else 600, # IU
            'vitaminE': 15,                       # mg
            'vitaminK': 120 if is_male else 90,   # μg
            'vitaminB1': 1.2 if is_male else 1.1, # mg
            'vitaminB2': 1.3 if is_male else 1.1, # mg
            'vitaminB6': 1.7 if age > 50 else 1.3,# mg
            'vitaminB12': 2.4,                    # μg
            'folate': 400,                        # μg
            'niacin': 16 if is_male else 14       # mg
        }
        
        # 特殊状态调整
        special_status = profile.get('special_status', [])
        if 'pregnancy' in special_status:
            targets['folate'] = 600
            targets['vitaminD'] = 600
        elif 'lactation' in special_status:
            targets['vitaminA'] = 1300
            targets['vitaminC'] = 120
            
        return targets
    
    def _calculate_mineral_targets(self, profile: Dict[str, Any]) -> Dict[str, float]:
        """计算矿物质需求（单位：mg）"""
        age = self._age_group_to_number(profile.get('age_group', '26to35'))
        is_male = profile.get('gender', 'other').lower() == 'male'
        
        targets = {
            'calcium': 1200 if age > 50 else 1000,          # mg
            'iron': 8 if is_male else (8 if age > 50 else 18), # mg
            'magnesium': 400 if is_male else 310,           # mg
            'phosphorus': 700,                               # mg
            'potassium': 3500,                               # mg
            'sodium': 2300,                                  # mg (上限)
            'zinc': 11 if is_male else 8,                   # mg
            'selenium': 55,                                  # μg
            'iodine': 150,                                   # μg
            'copper': 0.9                                    # mg
        }
        
        # 特殊状态调整
        special_status = profile.get('special_status', [])
        if 'pregnancy' in special_status:
            targets['iron'] = 27
            targets['zinc'] = 11
        elif 'lactation' in special_status:
            targets['iodine'] = 290
            targets['zinc'] = 12
            
        return targets
    
    def _get_macro_reasoning(self, health_goals: List[str]) -> str:
        """获取宏量营养素比例的推理说明"""
        if 'weight_loss' in health_goals or 'fat_loss' in health_goals:
            return "减重目标需要更高的蛋白质摄入以保持肌肉量，适度减少碳水化合物"
        elif 'muscle_gain' in health_goals:
            return "增肌目标需要高蛋白质摄入支持肌肉生长，充足碳水提供训练能量"
        elif 'endurance' in health_goals:
            return "耐力运动需要更多碳水化合物提供持续能量"
        else:
            return "均衡的营养素比例，符合中国营养学会推荐标准"