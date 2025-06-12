/**
 * 营养师类型和认证等级枚举
 * 基于中国营养学会认证体系和公共营养师职业技能等级标准
 */

module.exports = {
  // 营养师认证等级
  CERTIFICATION_LEVELS: {
    // 注册营养师
    REGISTERED_DIETITIAN: { 
      value: 'registered_dietitian', 
      label: '注册营养师(RD)', 
      description: '具有本科及以上学历，通过注册营养师水平评价考试' 
    },
    
    // 注册营养技师
    DIETETIC_TECHNICIAN: { 
      value: 'dietetic_technician', 
      label: '注册营养技师(DTR)', 
      description: '具有专科及以上学历，协助注册营养师开展营养工作' 
    },
    
    // 公共营养师四级（中级）
    PUBLIC_NUTRITIONIST_L4: { 
      value: 'public_nutritionist_l4', 
      label: '公共营养师四级', 
      description: '中级技能水平，具备基础营养指导能力' 
    },
    
    // 公共营养师三级（高级）
    PUBLIC_NUTRITIONIST_L3: { 
      value: 'public_nutritionist_l3', 
      label: '公共营养师三级', 
      description: '高级技能水平，具备综合营养咨询能力' 
    },
    
    // 营养管理师
    NUTRITION_MANAGER: { 
      value: 'nutrition_manager', 
      label: '营养管理师', 
      description: '具备营养管理和团队协调能力' 
    }
  },

  // 认证状态
  CERTIFICATION_STATUS: {
    DRAFT: { value: 'draft', label: '草稿', description: '申请未提交' },
    PENDING: { value: 'pending', label: '待审核', description: '已提交待管理员审核' },
    UNDER_REVIEW: { value: 'under_review', label: '审核中', description: '管理员正在审核' },
    APPROVED: { value: 'approved', label: '审核通过', description: '认证审核通过' },
    REJECTED: { value: 'rejected', label: '审核拒绝', description: '认证审核被拒绝' },
    SUSPENDED: { value: 'suspended', label: '暂停认证', description: '认证被暂停' },
    EXPIRED: { value: 'expired', label: '认证过期', description: '认证已过期需续期' }
  },

  // 专业领域
  SPECIALIZATION_AREAS: {
    CLINICAL_NUTRITION: { value: 'clinical_nutrition', label: '临床营养', description: '医院、诊所等医疗机构营养工作' },
    PUBLIC_NUTRITION: { value: 'public_nutrition', label: '公共营养', description: '社区、学校等公共场所营养指导' },
    FOOD_NUTRITION: { value: 'food_nutrition', label: '食品营养', description: '食品企业营养标签、产品开发' },
    SPORTS_NUTRITION: { value: 'sports_nutrition', label: '运动营养', description: '运动员、健身人群营养指导' },
    MATERNAL_CHILD: { value: 'maternal_child', label: '妇幼营养', description: '孕产妇、婴幼儿营养专业' },
    ELDERLY_NUTRITION: { value: 'elderly_nutrition', label: '老年营养', description: '老年人群营养健康管理' },
    WEIGHT_MANAGEMENT: { value: 'weight_management', label: '体重管理', description: '肥胖、减重营养干预' },
    FOOD_SAFETY: { value: 'food_safety', label: '食品安全', description: '食品安全检测与管理' }
  },

  // 学历要求
  EDUCATION_REQUIREMENTS: {
    DOCTORAL: { value: 'doctoral', label: '博士研究生', description: '博士学位' },
    MASTER: { value: 'master', label: '硕士研究生', description: '硕士学位' },
    BACHELOR: { value: 'bachelor', label: '本科', description: '学士学位' },
    ASSOCIATE: { value: 'associate', label: '专科', description: '专科学历' },
    TECHNICAL_SECONDARY: { value: 'technical_secondary', label: '中专', description: '中等专业学校' }
  },

  // 专业背景
  PROFESSIONAL_BACKGROUNDS: {
    NUTRITION: { value: 'nutrition', label: '营养学', description: '营养学专业' },
    FOOD_SCIENCE: { value: 'food_science', label: '食品科学', description: '食品科学与工程专业' },
    CLINICAL_MEDICINE: { value: 'clinical_medicine', label: '临床医学', description: '临床医学专业' },
    PREVENTIVE_MEDICINE: { value: 'preventive_medicine', label: '预防医学', description: '预防医学专业' },
    NURSING: { value: 'nursing', label: '护理学', description: '护理学专业' },
    PHARMACY: { value: 'pharmacy', label: '药学', description: '药学专业' },
    BIOCHEMISTRY: { value: 'biochemistry', label: '生物化学', description: '生物化学专业' },
    OTHER_RELATED: { value: 'other_related', label: '其他相关专业', description: '其他医学、食品、生物相关专业' }
  },

  // 工作经验要求
  WORK_EXPERIENCE_REQUIREMENTS: {
    NONE: { value: 'none', label: '无要求', years: 0, description: '在校学生或应届毕业生' },
    ONE_YEAR: { value: 'one_year', label: '1年以上', years: 1, description: '1年以上相关工作经验' },
    TWO_YEARS: { value: 'two_years', label: '2年以上', years: 2, description: '2年以上相关工作经验' },
    THREE_YEARS: { value: 'three_years', label: '3年以上', years: 3, description: '3年以上相关工作经验' },
    FIVE_YEARS: { value: 'five_years', label: '5年以上', years: 5, description: '5年以上相关工作经验' }
  },

  // 证书文件类型（简化版 - 对应简化需求）
  CERTIFICATE_TYPES: {
    NUTRITION_CERTIFICATE: { value: 'nutrition_certificate', label: '营养师资格证书', required: true, description: '营养师相关资格证书' },
    ID_CARD: { value: 'id_card', label: '身份证', required: false, description: '身份证正反面（可选）' },
    TRAINING_CERTIFICATE: { value: 'training_certificate', label: '培训证书', required: false, description: '相关培训结业证书（可选）' },
    OTHER_MATERIALS: { value: 'other_materials', label: '其他材料', required: false, description: '其他有助于申请的证明材料（可选）' }
  },

  // 审核文档要求
  DOCUMENT_REQUIREMENTS: {
    IMAGE_FORMATS: ['jpg', 'jpeg', 'png', 'pdf'],
    MAX_FILE_SIZE: 10 * 1024 * 1024, // 10MB
    MIN_RESOLUTION: { width: 800, height: 600 },
    PHOTO_REQUIREMENTS: {
      background: '白色或蓝色背景',
      size: '一寸照片(2.5cm × 3.5cm)',
      format: '正面免冠',
      clarity: '图像清晰，五官端正'
    }
  }
};