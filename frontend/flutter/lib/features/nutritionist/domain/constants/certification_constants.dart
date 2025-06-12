/// 营养师认证相关常量
class CertificationConstants {
  // 认证等级
  static const Map<String, String> certificationLevels = {
    'registered_dietitian': '注册营养师(RD)',
    'dietetic_technician': '注册营养技师(DTR)',
    'public_nutritionist_l4': '公共营养师四级',
    'public_nutritionist_l3': '公共营养师三级',
    'nutrition_manager': '营养管理师',
  };

  // 认证状态
  static const Map<String, String> certificationStatus = {
    'draft': '草稿',
    'pending': '待审核',
    'under_review': '审核中',
    'approved': '审核通过',
    'rejected': '审核拒绝',
    'suspended': '暂停认证',
    'expired': '认证过期',
  };

  // 专业领域
  static const Map<String, String> specializationAreas = {
    'clinical_nutrition': '临床营养',
    'public_nutrition': '公共营养',
    'food_nutrition': '食品营养',
    'sports_nutrition': '运动营养',
    'maternal_child': '妇幼营养',
    'elderly_nutrition': '老年营养',
    'weight_management': '体重管理',
    'food_safety': '食品安全',
  };

  // 学历要求
  static const Map<String, String> educationRequirements = {
    'doctoral': '博士研究生',
    'master': '硕士研究生',
    'bachelor': '本科',
    'associate': '专科',
    'technical_secondary': '中专',
  };

  // 专业背景
  static const Map<String, String> professionalBackgrounds = {
    'nutrition': '营养学',
    'food_science': '食品科学',
    'clinical_medicine': '临床医学',
    'preventive_medicine': '预防医学',
    'nursing': '护理学',
    'pharmacy': '药学',
    'biochemistry': '生物化学',
    'other_related': '其他相关专业',
  };

  // 工作经验要求
  static const Map<String, Map<String, dynamic>> workExperienceRequirements = {
    'none': {'label': '无要求', 'years': 0, 'description': '在校学生或应届毕业生'},
    'one_year': {'label': '1年以上', 'years': 1, 'description': '1年以上相关工作经验'},
    'two_years': {'label': '2年以上', 'years': 2, 'description': '2年以上相关工作经验'},
    'three_years': {'label': '3年以上', 'years': 3, 'description': '3年以上相关工作经验'},
    'five_years': {'label': '5年以上', 'years': 5, 'description': '5年以上相关工作经验'},
  };

  // 证书文件类型
  static const Map<String, Map<String, dynamic>> certificateTypes = {
    'degree_certificate': {
      'label': '学位证书',
      'required': true,
      'description': '学位证书扫描件'
    },
    'graduation_certificate': {
      'label': '毕业证书',
      'required': true,
      'description': '毕业证书扫描件'
    },
    'transcript': {
      'label': '成绩单',
      'required': false,
      'description': '学习成绩单'
    },
    'work_certificate': {
      'label': '工作证明',
      'required': true,
      'description': '工作单位出具的工作证明'
    },
    'professional_certificate': {
      'label': '专业证书',
      'required': false,
      'description': '已获得的专业资格证书'
    },
    'training_certificate': {
      'label': '培训证书',
      'required': false,
      'description': '相关培训结业证书'
    },
    'id_card': {
      'label': '身份证',
      'required': true,
      'description': '身份证正反面'
    },
    'profile_photo': {
      'label': '证件照',
      'required': true,
      'description': '一寸免冠证件照'
    },
  };

  // 文档要求
  static const Map<String, dynamic> documentRequirements = {
    'imageFormats': ['jpg', 'jpeg', 'png', 'pdf'],
    'maxFileSize': 10 * 1024 * 1024, // 10MB
    'minResolution': {'width': 800, 'height': 600},
    'photoRequirements': {
      'background': '白色或蓝色背景',
      'size': '一寸照片(2.5cm × 3.5cm)',
      'format': '正面免冠',
      'clarity': '图像清晰，五官端正'
    }
  };

  // 获取认证等级标签
  static String getCertificationLevelLabel(String value) {
    return certificationLevels[value] ?? value;
  }

  // 获取认证状态标签
  static String getCertificationStatusLabel(String value) {
    return certificationStatus[value] ?? value;
  }

  // 获取专业领域标签
  static String getSpecializationAreaLabel(String value) {
    return specializationAreas[value] ?? value;
  }

  // 获取学历标签
  static String getEducationLabel(String value) {
    return educationRequirements[value] ?? value;
  }

  // 获取专业背景标签
  static String getProfessionalBackgroundLabel(String value) {
    return professionalBackgrounds[value] ?? value;
  }

  // 获取工作经验标签
  static String getWorkExperienceLabel(String value) {
    return workExperienceRequirements[value]?['label'] ?? value;
  }

  // 获取证书类型标签
  static String getCertificateTypeLabel(String value) {
    return certificateTypes[value]?['label'] ?? value;
  }

  // 检查证书类型是否必需
  static bool isCertificateTypeRequired(String value) {
    return certificateTypes[value]?['required'] ?? false;
  }

  // 获取必需的证书类型
  static List<String> getRequiredCertificateTypes() {
    return certificateTypes.entries
        .where((entry) => entry.value['required'] == true)
        .map((entry) => entry.key)
        .toList();
  }

  // 验证文件格式
  static bool isValidImageFormat(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    return documentRequirements['imageFormats'].contains(extension);
  }

  // 验证文件大小
  static bool isValidFileSize(int fileSize) {
    return fileSize <= documentRequirements['maxFileSize'];
  }
}