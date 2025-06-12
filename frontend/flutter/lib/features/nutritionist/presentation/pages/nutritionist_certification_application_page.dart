import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/nutritionist_certification_service.dart';
import '../../domain/entities/nutritionist_certification.dart';
import '../widgets/steps/identity_verification_step.dart';
import '../widgets/steps/education_background_step.dart';
import '../widgets/steps/document_verification_step.dart';
import '../widgets/certification_step_indicator.dart';
import 'nutritionist_certification_status_page.dart';

/// 营养师认证申请页面 - 多步骤表单
/// 采用Material 3设计规范，包含5个完整步骤
class NutritionistCertificationApplicationPage extends ConsumerStatefulWidget {
  final String? applicationId;
  final NutritionistCertification? initialData;

  const NutritionistCertificationApplicationPage({
    Key? key,
    this.applicationId,
    this.initialData,
  }) : super(key: key);

  @override
  ConsumerState<NutritionistCertificationApplicationPage> createState() =>
      _NutritionistCertificationApplicationPageState();
}

class _NutritionistCertificationApplicationPageState
    extends ConsumerState<NutritionistCertificationApplicationPage>
    with TickerProviderStateMixin {
  
  late PageController _pageController;
  late AnimationController _animationController;
  int _currentStep = 0;
  static const int _totalSteps = 3;
  bool _isSubmitting = false;

  // 全局表单键 - 每个步骤一个
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    _totalSteps,
    (index) => GlobalKey<FormState>(),
  );

  // 步骤标题和描述
  static const List<Map<String, String>> _stepInfo = [
    {
      'title': '身份验证',
      'description': '实名认证验证',
      'icon': 'person',
    },
    {
      'title': '教育背景',
      'description': '学历专业信息',
      'icon': 'school',
    },
    {
      'title': '文档验证',
      'description': '上传证明材料',
      'icon': 'verified',
    },
  ];

  // 表单数据存储
  Map<String, dynamic> _formData = {
    'personalInfo': {
      'fullName': '',
      'idNumber': '',
      'phone': '', // 必需字段
    },
    'certificationInfo': {
      'specializationAreas': <String>[], // 必需字段
      'workYearsInNutrition': 0, // 必需字段
    },
    'education': {
      'degree': null,
      'major': null,
      'school': null,
    },
    'documents': <Map<String, dynamic>>[],
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    if (widget.initialData != null) {
      _loadInitialData();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _loadInitialData() {
    // TODO: 从现有数据加载表单数据
    final data = widget.initialData!;
    // 这里需要根据实际的数据结构来映射
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('营养师认证申请'),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _handleBackPressed,
        ),
      ),
      body: Column(
        children: [
          // 步骤指示器
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: CertificationStepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              stepInfo: _stepInfo,
              onStepTapped: _canNavigateToStep,
            ),
          ),
          
          // 表单内容
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
                _animationController.forward(from: 0);
              },
              children: [
                IdentityVerificationStep(
                  formKey: _formKeys[0],
                  formData: _formData['personalInfo'] as Map<String, dynamic>,
                  onDataChanged: _updateFormData,
                ),
                EducationBackgroundStep(
                  formKey: _formKeys[1],
                  formData: _formData['education'] as Map<String, dynamic>,
                  onDataChanged: _updateFormData,
                ),
                DocumentVerificationStep(
                  formKey: _formKeys[2],
                  formData: _formData['documents'] as List<Map<String, dynamic>>,
                  onDataChanged: _updateFormData,
                ),
              ],
            ),
          ),
          
          // 底部导航按钮
          _buildBottomNavigation(context),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 上一步按钮
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _previousStep,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('上一步'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            
            if (_currentStep > 0) const SizedBox(width: 16),
            
            // 下一步/提交按钮
            Expanded(
              flex: _currentStep == 0 ? 1 : 1,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _handleNextOrSubmit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(_currentStep < _totalSteps - 1
                        ? Icons.arrow_forward
                        : Icons.check),
                label: Text(_isSubmitting
                    ? '提交中...'
                    : _currentStep < _totalSteps - 1
                        ? '下一步'
                        : '提交申请'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateFormData(String section, Map<String, dynamic> data) {
    setState(() {
      if (section == 'documents') {
        _formData[section] = data['documents'];
      } else {
        _formData[section] = {..._formData[section] as Map<String, dynamic>, ...data};
      }
    });
  }

  bool _canNavigateToStep(int stepIndex) {
    // 只能向前导航到已完成的步骤或下一个步骤
    return stepIndex <= _currentStep + 1;
  }

  void _handleBackPressed() {
    if (_currentStep > 0) {
      _previousStep();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _handleNextOrSubmit() async {
    if (_currentStep < _totalSteps - 1) {
      await _nextStep();
    } else {
      await _submitApplication();
    }
  }

  Future<void> _nextStep() async {
    // 验证当前步骤
    if (!_validateCurrentStep()) {
      return;
    }

    // 导航到下一步
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _validateCurrentStep() {
    final currentFormKey = _formKeys[_currentStep];
    if (currentFormKey.currentState == null) {
      return true; // 如果没有表单，直接通过
    }
    
    bool isValid = currentFormKey.currentState!.validate();
    
    // 特殊验证逻辑
    switch (_currentStep) {
      case 0: // 身份验证步骤
        // 验证姓名和身份证号
        final identityData = _formData['personalInfo'] as Map<String, dynamic>?;
        if (identityData == null || 
            identityData['fullName']?.toString().trim().isEmpty == true ||
            identityData['idNumber']?.toString().trim().isEmpty == true ||
            identityData['phone']?.toString().trim().isEmpty == true) {
          _showErrorMessage('请完善身份信息');
          return false;
        }
        break;
      case 1: // 教育背景步骤
        // 验证学历、专业、学校
        final educationData = _formData['education'] as Map<String, dynamic>?;
        if (educationData == null || 
            educationData['degree']?.toString().trim().isEmpty == true ||
            educationData['major']?.toString().trim().isEmpty == true ||
            educationData['school']?.toString().trim().isEmpty == true) {
          _showErrorMessage('请完善教育背景信息');
          return false;
        }
        
        // 验证认证信息
        final certificationData = _formData['certificationInfo'] as Map<String, dynamic>?;
        if (certificationData == null) {
          _showErrorMessage('请完善认证信息');
          return false;
        }
        
        final specializationAreas = certificationData['specializationAreas'] as List<String>?;
        if (specializationAreas == null || specializationAreas.isEmpty) {
          _showErrorMessage('请至少选择一个专长领域');
          return false;
        }
        break;
      case 2: // 文档验证步骤
        // 验证必需文档是否上传（学历证书）
        final documents = _formData['documents'] as List<Map<String, dynamic>>?;
        if (documents == null || documents.isEmpty) {
          _showErrorMessage('请上传学历证书');
          return false;
        }
        final hasEducationCert = documents.any((doc) => 
            doc['documentType'] == 'education_certificate');
        if (!hasEducationCert) {
          _showErrorMessage('请上传学历证书（必需文档）');
          return false;
        }
        break;
    }
    
    return isValid;
  }

  Future<void> _submitApplication() async {
    // 验证所有步骤
    bool allValid = true;
    for (int i = 0; i < _totalSteps; i++) {
      if (_formKeys[i].currentState != null) {
        if (!_formKeys[i].currentState!.validate()) {
          allValid = false;
          // 跳转到第一个有错误的步骤
          if (i != _currentStep) {
            _pageController.animateToPage(
              i,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
          break;
        }
      }
    }

    if (!allValid) {
      _showErrorMessage('请完善所有必填信息');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final service = ref.read(nutritionistCertificationServiceProvider);
      
      // 创建或更新申请
      NutritionistCertification application;
      if (widget.applicationId != null) {
        application = await service.updateApplicationFromMap(
          widget.applicationId!,
          _formData,
        );
      } else {
        application = await service.createApplicationFromMap(_formData);
      }

      // 提交申请
      await service.submitApplication(application.id);

      // 导航到状态页面
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NutritionistCertificationStatusPage(
              applicationId: application.id,
            ),
          ),
        );
      }

    } catch (e) {
      _showErrorMessage('提交失败：$e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}