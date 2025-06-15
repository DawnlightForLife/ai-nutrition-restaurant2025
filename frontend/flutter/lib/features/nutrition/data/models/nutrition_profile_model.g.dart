// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrition_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NutritionProfileModel _$NutritionProfileModelFromJson(
        Map<String, dynamic> json) =>
    NutritionProfileModel(
      id: json['_id'] as String?,
      userId: json['user_id'] as String,
      profileName: json['profile_name'] as String,
      gender: json['gender'] as String,
      ageGroup: json['age_group'] as String?,
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
      activityLevel: json['activity_level'] as String?,
      activityLevelDetail: json['activityLevelDetail'] as String?,
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      dietaryPreferences: json['dietary_preferences'] == null
          ? null
          : DietaryPreferencesModel.fromJson(
              json['dietary_preferences'] as Map<String, dynamic>),
      lifestyle: json['lifestyle'] == null
          ? null
          : LifestyleModel.fromJson(json['lifestyle'] as Map<String, dynamic>),
      nutritionGoals: (json['nutrition_goals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      healthGoalDetails: json['health_goal_details'] == null
          ? null
          : HealthGoalDetailsModel.fromJson(
              json['health_goal_details'] as Map<String, dynamic>),
      activityDetails: json['activity_details'] as Map<String, dynamic>?,
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      dailyCalorieTarget: (json['daily_calorie_target'] as num?)?.toDouble(),
      hydrationGoal: (json['hydration_goal'] as num?)?.toDouble(),
      medicalConditions: (json['medical_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      preferredMealTimes: (json['preferred_meal_times'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mealFrequency: (json['meal_frequency'] as num?)?.toInt(),
      cookingTimeBudget: (json['cooking_time_budget'] as num?)?.toInt(),
      region: json['region'] == null
          ? null
          : RegionModel.fromJson(json['region'] as Map<String, dynamic>),
      occupation: json['occupation'] as String?,
      nutritionStatus: json['nutrition_status'] == null
          ? null
          : NutritionStatusModel.fromJson(
              json['nutrition_status'] as Map<String, dynamic>),
      relatedHealthRecords: (json['related_health_records'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isPrimary: json['is_primary'] as bool? ?? false,
      archived: json['archived'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$NutritionProfileModelToJson(
        NutritionProfileModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) '_id': value,
      'user_id': instance.userId,
      'profile_name': instance.profileName,
      'gender': instance.gender,
      if (instance.ageGroup case final value?) 'age_group': value,
      if (instance.height case final value?) 'height': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.activityLevel case final value?) 'activity_level': value,
      if (instance.activityLevelDetail case final value?)
        'activityLevelDetail': value,
      if (instance.bodyFatPercentage case final value?)
        'body_fat_percentage': value,
      if (instance.dietaryPreferences?.toJson() case final value?)
        'dietary_preferences': value,
      if (instance.lifestyle?.toJson() case final value?) 'lifestyle': value,
      'nutrition_goals': instance.nutritionGoals,
      if (instance.healthGoalDetails?.toJson() case final value?)
        'health_goal_details': value,
      if (instance.activityDetails case final value?) 'activity_details': value,
      if (instance.targetWeight case final value?) 'target_weight': value,
      if (instance.dailyCalorieTarget case final value?)
        'daily_calorie_target': value,
      if (instance.hydrationGoal case final value?) 'hydration_goal': value,
      if (instance.medicalConditions case final value?)
        'medical_conditions': value,
      if (instance.preferredMealTimes case final value?)
        'preferred_meal_times': value,
      if (instance.mealFrequency case final value?) 'meal_frequency': value,
      if (instance.cookingTimeBudget case final value?)
        'cooking_time_budget': value,
      if (instance.region?.toJson() case final value?) 'region': value,
      if (instance.occupation case final value?) 'occupation': value,
      if (instance.nutritionStatus?.toJson() case final value?)
        'nutrition_status': value,
      if (instance.relatedHealthRecords case final value?)
        'related_health_records': value,
      'is_primary': instance.isPrimary,
      'archived': instance.archived,
      if (instance.createdAt?.toIso8601String() case final value?)
        'created_at': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updated_at': value,
    };

DietaryPreferencesModel _$DietaryPreferencesModelFromJson(
        Map<String, dynamic> json) =>
    DietaryPreferencesModel(
      dietaryType: json['dietary_type'] as String?,
      cuisinePreferences: (json['cuisine_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      ethnicDietary: json['ethnic_dietary'] as String?,
      religiousDietary: json['religious_dietary'] as String?,
      tastePreferences: json['taste_preferences'] == null
          ? null
          : TastePreferencesModel.fromJson(
              json['taste_preferences'] as Map<String, dynamic>),
      taboos:
          (json['taboos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialRequirements: (json['special_requirements'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      forbiddenIngredients: (json['forbidden_ingredients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      nutritionPreferences: (json['nutrition_preferences'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vegetarian: json['vegetarian'] as bool?,
      vegan: json['vegan'] as bool?,
      lowCarb: json['low_carb'] as bool?,
      glutenFree: json['gluten_free'] as bool?,
      dairyFree: json['dairy_free'] as bool?,
      keto: json['keto'] as bool?,
      paleo: json['paleo'] as bool?,
      halal: json['halal'] as bool?,
      kosher: json['kosher'] as bool?,
    );

Map<String, dynamic> _$DietaryPreferencesModelToJson(
        DietaryPreferencesModel instance) =>
    <String, dynamic>{
      if (instance.dietaryType case final value?) 'dietary_type': value,
      if (instance.cuisinePreferences case final value?)
        'cuisine_preferences': value,
      if (instance.ethnicDietary case final value?) 'ethnic_dietary': value,
      if (instance.religiousDietary case final value?)
        'religious_dietary': value,
      if (instance.tastePreferences?.toJson() case final value?)
        'taste_preferences': value,
      if (instance.taboos case final value?) 'taboos': value,
      if (instance.allergies case final value?) 'allergies': value,
      if (instance.specialRequirements case final value?)
        'special_requirements': value,
      if (instance.forbiddenIngredients case final value?)
        'forbidden_ingredients': value,
      if (instance.nutritionPreferences case final value?)
        'nutrition_preferences': value,
      if (instance.vegetarian case final value?) 'vegetarian': value,
      if (instance.vegan case final value?) 'vegan': value,
      if (instance.lowCarb case final value?) 'low_carb': value,
      if (instance.glutenFree case final value?) 'gluten_free': value,
      if (instance.dairyFree case final value?) 'dairy_free': value,
      if (instance.keto case final value?) 'keto': value,
      if (instance.paleo case final value?) 'paleo': value,
      if (instance.halal case final value?) 'halal': value,
      if (instance.kosher case final value?) 'kosher': value,
    };

TastePreferencesModel _$TastePreferencesModelFromJson(
        Map<String, dynamic> json) =>
    TastePreferencesModel(
      spicy: (json['spicy'] as num?)?.toInt(),
      salty: (json['salty'] as num?)?.toInt(),
      sweet: (json['sweet'] as num?)?.toInt(),
      sour: (json['sour'] as num?)?.toInt(),
      oily: (json['oily'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TastePreferencesModelToJson(
        TastePreferencesModel instance) =>
    <String, dynamic>{
      if (instance.spicy case final value?) 'spicy': value,
      if (instance.salty case final value?) 'salty': value,
      if (instance.sweet case final value?) 'sweet': value,
      if (instance.sour case final value?) 'sour': value,
      if (instance.oily case final value?) 'oily': value,
    };

LifestyleModel _$LifestyleModelFromJson(Map<String, dynamic> json) =>
    LifestyleModel(
      smoking: json['smoking'] as bool?,
      drinking: json['drinking'] as bool?,
      sleepDuration: (json['sleep_duration'] as num?)?.toDouble(),
      exerciseFrequency: json['exercise_frequency'] as String?,
      exerciseTypes: (json['exercise_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      trainingIntensity: json['training_intensity'] as String?,
      weeklyExerciseHours: (json['weekly_exercise_hours'] as num?)?.toDouble(),
      preferredExerciseTime: json['preferred_exercise_time'] as String?,
      specialStatus: (json['special_status'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LifestyleModelToJson(LifestyleModel instance) =>
    <String, dynamic>{
      if (instance.smoking case final value?) 'smoking': value,
      if (instance.drinking case final value?) 'drinking': value,
      if (instance.sleepDuration case final value?) 'sleep_duration': value,
      if (instance.exerciseFrequency case final value?)
        'exercise_frequency': value,
      if (instance.exerciseTypes case final value?) 'exercise_types': value,
      if (instance.trainingIntensity case final value?)
        'training_intensity': value,
      if (instance.weeklyExerciseHours case final value?)
        'weekly_exercise_hours': value,
      if (instance.preferredExerciseTime case final value?)
        'preferred_exercise_time': value,
      if (instance.specialStatus case final value?) 'special_status': value,
    };

RegionModel _$RegionModelFromJson(Map<String, dynamic> json) => RegionModel(
      province: json['province'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$RegionModelToJson(RegionModel instance) =>
    <String, dynamic>{
      if (instance.province case final value?) 'province': value,
      if (instance.city case final value?) 'city': value,
    };

NutritionStatusModel _$NutritionStatusModelFromJson(
        Map<String, dynamic> json) =>
    NutritionStatusModel(
      chronicDiseases: (json['chronic_diseases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      specialConditions: (json['special_conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      allergies: (json['allergies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
      nutritionalBiomarkers:
          json['nutritional_biomarkers'] as Map<String, dynamic>?,
      micronutrientStatus:
          json['micronutrient_status'] as Map<String, dynamic>?,
      metabolicIndicators: json['metabolic_indicators'] == null
          ? null
          : MetabolicIndicatorsModel.fromJson(
              json['metabolic_indicators'] as Map<String, dynamic>),
      bodyComposition: json['body_composition'] == null
          ? null
          : BodyCompositionModel.fromJson(
              json['body_composition'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NutritionStatusModelToJson(
        NutritionStatusModel instance) =>
    <String, dynamic>{
      if (instance.chronicDiseases case final value?) 'chronic_diseases': value,
      if (instance.specialConditions case final value?)
        'special_conditions': value,
      if (instance.allergies case final value?) 'allergies': value,
      if (instance.notes case final value?) 'notes': value,
      if (instance.nutritionalBiomarkers case final value?)
        'nutritional_biomarkers': value,
      if (instance.micronutrientStatus case final value?)
        'micronutrient_status': value,
      if (instance.metabolicIndicators?.toJson() case final value?)
        'metabolic_indicators': value,
      if (instance.bodyComposition?.toJson() case final value?)
        'body_composition': value,
    };

MetabolicIndicatorsModel _$MetabolicIndicatorsModelFromJson(
        Map<String, dynamic> json) =>
    MetabolicIndicatorsModel(
      bloodGlucose: json['blood_glucose'] == null
          ? null
          : BloodGlucoseModel.fromJson(
              json['blood_glucose'] as Map<String, dynamic>),
      lipidProfile: json['lipid_profile'] == null
          ? null
          : LipidProfileModel.fromJson(
              json['lipid_profile'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetabolicIndicatorsModelToJson(
        MetabolicIndicatorsModel instance) =>
    <String, dynamic>{
      if (instance.bloodGlucose?.toJson() case final value?)
        'blood_glucose': value,
      if (instance.lipidProfile?.toJson() case final value?)
        'lipid_profile': value,
    };

BloodGlucoseModel _$BloodGlucoseModelFromJson(Map<String, dynamic> json) =>
    BloodGlucoseModel(
      fasting: (json['fasting'] as num?)?.toDouble(),
      postprandial: (json['postprandial'] as num?)?.toDouble(),
      hba1c: (json['hba1c'] as num?)?.toDouble(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$BloodGlucoseModelToJson(BloodGlucoseModel instance) =>
    <String, dynamic>{
      if (instance.fasting case final value?) 'fasting': value,
      if (instance.postprandial case final value?) 'postprandial': value,
      if (instance.hba1c case final value?) 'hba1c': value,
      if (instance.lastUpdated?.toIso8601String() case final value?)
        'last_updated': value,
    };

LipidProfileModel _$LipidProfileModelFromJson(Map<String, dynamic> json) =>
    LipidProfileModel(
      totalCholesterol: (json['total_cholesterol'] as num?)?.toDouble(),
      hdl: (json['hdl'] as num?)?.toDouble(),
      ldl: (json['ldl'] as num?)?.toDouble(),
      triglycerides: (json['triglycerides'] as num?)?.toDouble(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$LipidProfileModelToJson(LipidProfileModel instance) =>
    <String, dynamic>{
      if (instance.totalCholesterol case final value?)
        'total_cholesterol': value,
      if (instance.hdl case final value?) 'hdl': value,
      if (instance.ldl case final value?) 'ldl': value,
      if (instance.triglycerides case final value?) 'triglycerides': value,
      if (instance.lastUpdated?.toIso8601String() case final value?)
        'last_updated': value,
    };

BodyCompositionModel _$BodyCompositionModelFromJson(
        Map<String, dynamic> json) =>
    BodyCompositionModel(
      bodyFatPercentage: (json['body_fat_percentage'] as num?)?.toDouble(),
      muscleMass: (json['muscle_mass'] as num?)?.toDouble(),
      visceralFat: (json['visceral_fat'] as num?)?.toDouble(),
      boneDensity: (json['bone_density'] as num?)?.toDouble(),
      lastUpdated: json['last_updated'] == null
          ? null
          : DateTime.parse(json['last_updated'] as String),
    );

Map<String, dynamic> _$BodyCompositionModelToJson(
        BodyCompositionModel instance) =>
    <String, dynamic>{
      if (instance.bodyFatPercentage case final value?)
        'body_fat_percentage': value,
      if (instance.muscleMass case final value?) 'muscle_mass': value,
      if (instance.visceralFat case final value?) 'visceral_fat': value,
      if (instance.boneDensity case final value?) 'bone_density': value,
      if (instance.lastUpdated?.toIso8601String() case final value?)
        'last_updated': value,
    };

HealthGoalDetailsModel _$HealthGoalDetailsModelFromJson(
        Map<String, dynamic> json) =>
    HealthGoalDetailsModel(
      bloodSugarControl: json['blood_sugar_control'] == null
          ? null
          : BloodSugarControlModel.fromJson(
              json['blood_sugar_control'] as Map<String, dynamic>),
      bloodPressureControl: json['blood_pressure_control'] == null
          ? null
          : BloodPressureControlModel.fromJson(
              json['blood_pressure_control'] as Map<String, dynamic>),
      cholesterolManagement: json['cholesterol_management'] == null
          ? null
          : CholesterolManagementModel.fromJson(
              json['cholesterol_management'] as Map<String, dynamic>),
      weightManagement: json['weight_management'] == null
          ? null
          : WeightManagementModel.fromJson(
              json['weight_management'] as Map<String, dynamic>),
      sportsNutrition: json['sports_nutrition'] == null
          ? null
          : SportsNutritionModel.fromJson(
              json['sports_nutrition'] as Map<String, dynamic>),
      specialPhysiological: json['special_physiological'] == null
          ? null
          : SpecialPhysiologicalModel.fromJson(
              json['special_physiological'] as Map<String, dynamic>),
      digestiveHealth: json['digestive_health'] == null
          ? null
          : DigestiveHealthModel.fromJson(
              json['digestive_health'] as Map<String, dynamic>),
      immunityBoost: json['immunity_boost'] == null
          ? null
          : ImmunityBoostModel.fromJson(
              json['immunity_boost'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HealthGoalDetailsModelToJson(
        HealthGoalDetailsModel instance) =>
    <String, dynamic>{
      if (instance.bloodSugarControl?.toJson() case final value?)
        'blood_sugar_control': value,
      if (instance.bloodPressureControl?.toJson() case final value?)
        'blood_pressure_control': value,
      if (instance.cholesterolManagement?.toJson() case final value?)
        'cholesterol_management': value,
      if (instance.weightManagement?.toJson() case final value?)
        'weight_management': value,
      if (instance.sportsNutrition?.toJson() case final value?)
        'sports_nutrition': value,
      if (instance.specialPhysiological?.toJson() case final value?)
        'special_physiological': value,
      if (instance.digestiveHealth?.toJson() case final value?)
        'digestive_health': value,
      if (instance.immunityBoost?.toJson() case final value?)
        'immunity_boost': value,
    };

BloodSugarControlModel _$BloodSugarControlModelFromJson(
        Map<String, dynamic> json) =>
    BloodSugarControlModel(
      fastingGlucose: (json['fasting_glucose'] as num?)?.toDouble(),
      postprandialGlucose: (json['postprandial_glucose'] as num?)?.toDouble(),
      hba1c: (json['hba1c'] as num?)?.toDouble(),
      diabetesType: json['diabetes_type'] as String?,
      medicationStatus: json['medication_status'] as String?,
      monitoringFrequency: json['monitoring_frequency'] as String?,
    );

Map<String, dynamic> _$BloodSugarControlModelToJson(
        BloodSugarControlModel instance) =>
    <String, dynamic>{
      if (instance.fastingGlucose case final value?) 'fasting_glucose': value,
      if (instance.postprandialGlucose case final value?)
        'postprandial_glucose': value,
      if (instance.hba1c case final value?) 'hba1c': value,
      if (instance.diabetesType case final value?) 'diabetes_type': value,
      if (instance.medicationStatus case final value?)
        'medication_status': value,
      if (instance.monitoringFrequency case final value?)
        'monitoring_frequency': value,
    };

BloodPressureControlModel _$BloodPressureControlModelFromJson(
        Map<String, dynamic> json) =>
    BloodPressureControlModel(
      systolic: (json['systolic'] as num?)?.toDouble(),
      diastolic: (json['diastolic'] as num?)?.toDouble(),
      hypertensionGrade: json['hypertension_grade'] as String?,
      medications: (json['medications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasComplication: json['has_complication'] as bool?,
    );

Map<String, dynamic> _$BloodPressureControlModelToJson(
        BloodPressureControlModel instance) =>
    <String, dynamic>{
      if (instance.systolic case final value?) 'systolic': value,
      if (instance.diastolic case final value?) 'diastolic': value,
      if (instance.hypertensionGrade case final value?)
        'hypertension_grade': value,
      if (instance.medications case final value?) 'medications': value,
      if (instance.hasComplication case final value?) 'has_complication': value,
    };

CholesterolManagementModel _$CholesterolManagementModelFromJson(
        Map<String, dynamic> json) =>
    CholesterolManagementModel(
      totalCholesterol: (json['total_cholesterol'] as num?)?.toDouble(),
      triglycerides: (json['triglycerides'] as num?)?.toDouble(),
      ldlCholesterol: (json['ldl_cholesterol'] as num?)?.toDouble(),
      hdlCholesterol: (json['hdl_cholesterol'] as num?)?.toDouble(),
      onStatins: json['on_statins'] as bool?,
    );

Map<String, dynamic> _$CholesterolManagementModelToJson(
        CholesterolManagementModel instance) =>
    <String, dynamic>{
      if (instance.totalCholesterol case final value?)
        'total_cholesterol': value,
      if (instance.triglycerides case final value?) 'triglycerides': value,
      if (instance.ldlCholesterol case final value?) 'ldl_cholesterol': value,
      if (instance.hdlCholesterol case final value?) 'hdl_cholesterol': value,
      if (instance.onStatins case final value?) 'on_statins': value,
    };

WeightManagementModel _$WeightManagementModelFromJson(
        Map<String, dynamic> json) =>
    WeightManagementModel(
      targetWeight: (json['target_weight'] as num?)?.toDouble(),
      targetBodyFat: (json['target_body_fat'] as num?)?.toDouble(),
      targetType: json['target_type'] as String?,
      targetSpeed: json['target_speed'] as String?,
      targetDate: json['target_date'] == null
          ? null
          : DateTime.parse(json['target_date'] as String),
      weightHistory: (json['weight_history'] as List<dynamic>?)
          ?.map((e) => WeightHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WeightManagementModelToJson(
        WeightManagementModel instance) =>
    <String, dynamic>{
      if (instance.targetWeight case final value?) 'target_weight': value,
      if (instance.targetBodyFat case final value?) 'target_body_fat': value,
      if (instance.targetType case final value?) 'target_type': value,
      if (instance.targetSpeed case final value?) 'target_speed': value,
      if (instance.targetDate?.toIso8601String() case final value?)
        'target_date': value,
      if (instance.weightHistory?.map((e) => e.toJson()).toList()
          case final value?)
        'weight_history': value,
    };

WeightHistoryModel _$WeightHistoryModelFromJson(Map<String, dynamic> json) =>
    WeightHistoryModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      weight: (json['weight'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$WeightHistoryModelToJson(WeightHistoryModel instance) =>
    <String, dynamic>{
      if (instance.date?.toIso8601String() case final value?) 'date': value,
      if (instance.weight case final value?) 'weight': value,
    };

SportsNutritionModel _$SportsNutritionModelFromJson(
        Map<String, dynamic> json) =>
    SportsNutritionModel(
      sportTypes: (json['sport_types'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      trainingPhase: json['training_phase'] as String?,
      competitionDate: json['competition_date'] == null
          ? null
          : DateTime.parse(json['competition_date'] as String),
      supplementUse: (json['supplement_use'] as List<dynamic>?)
          ?.map((e) => SupplementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SportsNutritionModelToJson(
        SportsNutritionModel instance) =>
    <String, dynamic>{
      if (instance.sportTypes case final value?) 'sport_types': value,
      if (instance.trainingPhase case final value?) 'training_phase': value,
      if (instance.competitionDate?.toIso8601String() case final value?)
        'competition_date': value,
      if (instance.supplementUse?.map((e) => e.toJson()).toList()
          case final value?)
        'supplement_use': value,
    };

SupplementModel _$SupplementModelFromJson(Map<String, dynamic> json) =>
    SupplementModel(
      name: json['name'] as String?,
      dosage: json['dosage'] as String?,
      timing: json['timing'] as String?,
    );

Map<String, dynamic> _$SupplementModelToJson(SupplementModel instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.dosage case final value?) 'dosage': value,
      if (instance.timing case final value?) 'timing': value,
    };

SpecialPhysiologicalModel _$SpecialPhysiologicalModelFromJson(
        Map<String, dynamic> json) =>
    SpecialPhysiologicalModel(
      pregnancyWeek: (json['pregnancy_week'] as num?)?.toInt(),
      lactationMonth: (json['lactation_month'] as num?)?.toInt(),
      menopauseStage: json['menopause_stage'] as String?,
      fertilityPlanning: json['fertility_planning'] as bool?,
    );

Map<String, dynamic> _$SpecialPhysiologicalModelToJson(
        SpecialPhysiologicalModel instance) =>
    <String, dynamic>{
      if (instance.pregnancyWeek case final value?) 'pregnancy_week': value,
      if (instance.lactationMonth case final value?) 'lactation_month': value,
      if (instance.menopauseStage case final value?) 'menopause_stage': value,
      if (instance.fertilityPlanning case final value?)
        'fertility_planning': value,
    };

DigestiveHealthModel _$DigestiveHealthModelFromJson(
        Map<String, dynamic> json) =>
    DigestiveHealthModel(
      symptoms: (json['symptoms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      foodIntolerances: (json['food_intolerances'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hPyloriStatus: json['h_pylori_status'] as String?,
      gutMicrobiomeTest: json['gut_microbiome_test'] == null
          ? null
          : GutMicrobiomeTestModel.fromJson(
              json['gut_microbiome_test'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DigestiveHealthModelToJson(
        DigestiveHealthModel instance) =>
    <String, dynamic>{
      if (instance.symptoms case final value?) 'symptoms': value,
      if (instance.foodIntolerances case final value?)
        'food_intolerances': value,
      if (instance.hPyloriStatus case final value?) 'h_pylori_status': value,
      if (instance.gutMicrobiomeTest?.toJson() case final value?)
        'gut_microbiome_test': value,
    };

GutMicrobiomeTestModel _$GutMicrobiomeTestModelFromJson(
        Map<String, dynamic> json) =>
    GutMicrobiomeTestModel(
      tested: json['tested'] as bool?,
      testDate: json['test_date'] == null
          ? null
          : DateTime.parse(json['test_date'] as String),
      results: json['results'] as String?,
    );

Map<String, dynamic> _$GutMicrobiomeTestModelToJson(
        GutMicrobiomeTestModel instance) =>
    <String, dynamic>{
      if (instance.tested case final value?) 'tested': value,
      if (instance.testDate?.toIso8601String() case final value?)
        'test_date': value,
      if (instance.results case final value?) 'results': value,
    };

ImmunityBoostModel _$ImmunityBoostModelFromJson(Map<String, dynamic> json) =>
    ImmunityBoostModel(
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      autoimmuneDiseases: (json['autoimmune_diseases'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      inflammationMarkers: json['inflammation_markers'] == null
          ? null
          : InflammationMarkersModel.fromJson(
              json['inflammation_markers'] as Map<String, dynamic>),
      infectionFrequency: json['infection_frequency'] as String?,
    );

Map<String, dynamic> _$ImmunityBoostModelToJson(ImmunityBoostModel instance) =>
    <String, dynamic>{
      if (instance.allergens case final value?) 'allergens': value,
      if (instance.autoimmuneDiseases case final value?)
        'autoimmune_diseases': value,
      if (instance.inflammationMarkers?.toJson() case final value?)
        'inflammation_markers': value,
      if (instance.infectionFrequency case final value?)
        'infection_frequency': value,
    };

InflammationMarkersModel _$InflammationMarkersModelFromJson(
        Map<String, dynamic> json) =>
    InflammationMarkersModel(
      crp: (json['crp'] as num?)?.toDouble(),
      esr: (json['esr'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$InflammationMarkersModelToJson(
        InflammationMarkersModel instance) =>
    <String, dynamic>{
      if (instance.crp case final value?) 'crp': value,
      if (instance.esr case final value?) 'esr': value,
    };
