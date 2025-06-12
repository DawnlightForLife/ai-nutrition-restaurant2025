import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/merchant_application_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/address_selector_widget.dart';

/// 改进版商家申请页面
class MerchantApplicationImprovedPage extends ConsumerStatefulWidget {
  const MerchantApplicationImprovedPage({super.key});

  @override
  ConsumerState<MerchantApplicationImprovedPage> createState() => _MerchantApplicationImprovedPageState();
}

class _MerchantApplicationImprovedPageState extends ConsumerState<MerchantApplicationImprovedPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedBusinessType = 'restaurant';
  String _selectedProvince = '';
  String _selectedCity = '';
  String _selectedDistrict = '';
  String _detailAddress = '';

  final List<Map<String, String>> _businessTypes = [
    {'value': 'maternityCenter', 'label': '月子中心'},
    {'value': 'gym', 'label': '健身房'},
    {'value': 'schoolCompany', 'label': '学校/公司'},
    {'value': 'restaurant', 'label': '餐厅'},
  ];

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// 初始化表单数据
  void _initializeFormData() {
    // 延迟初始化，确保Provider已经可用
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authStateProvider);
      final user = authState.user;
      
      if (user != null && mounted) {
        setState(() {
          // 预填用户电话
          if (user.phone.isNotEmpty) {
            _phoneController.text = user.phone;
          }
          // 使用phone作为默认email，或者留空让用户填写
          if (_emailController.text.isEmpty) {
            _emailController.text = '${user.phone}@example.com';
          }
        });
      }
      
      // 检查是否有编辑模式的数据
      _checkEditMode();
    });
  }
  
  /// 检查是否是编辑模式
  void _checkEditMode() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['mode'] == 'edit' && args['applicationData'] != null) {
        _populateFormWithExistingData(args['applicationData']);
      }
    });
  }
  
  /// 使用现有数据填充表单
  void _populateFormWithExistingData(Map<String, dynamic> data) {
    setState(() {
      _businessNameController.text = data['businessName'] ?? '';
      _selectedBusinessType = data['businessType'] ?? 'restaurant';
      _registrationNumberController.text = data['registrationNumber'] ?? '';
      _taxIdController.text = data['taxId'] ?? '';
      _emailController.text = data['contact']?['email'] ?? '';
      _phoneController.text = data['contact']?['phone'] ?? '';
      _selectedProvince = data['address']?['state'] ?? '';
      _selectedCity = data['address']?['city'] ?? '';
      _detailAddress = data['address']?['line1'] ?? '';
    });
  }

  /// 根据选择的地址更新店铺名称
  void _updateBusinessName() {
    String cityName = _selectedCity.isNotEmpty ? _selectedCity : 
                     _selectedProvince.isNotEmpty ? _selectedProvince : '未知';
    if (cityName.endsWith('市')) {
      cityName = cityName.substring(0, cityName.length - 1);
    }
    _businessNameController.text = '营养立方${cityName}加盟店';
  }

  @override
  Widget build(BuildContext context) {
    final applicationState = ref.watch(merchantApplicationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('商家入驻申请'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: applicationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  _buildSectionTitle('基本信息'),
                  _buildBusinessNameField(),
                  SizedBox(height: 16.h),
                  _buildBusinessTypeField(),
                  SizedBox(height: 16.h),
                  _buildRegistrationNumberField(),
                  SizedBox(height: 16.h),
                  _buildTaxIdField(),
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('联系信息'),
                  _buildEmailField(),
                  SizedBox(height: 16.h),
                  _buildPhoneField(),
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('地址信息'),
                  _buildAddressSelector(),
                  SizedBox(height: 16.h),
                  _buildDetailAddressField(),
                  SizedBox(height: 32.h),
                  
                  _buildSubmitButton(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildBusinessNameField() {
    return TextFormField(
      controller: _businessNameController,
      decoration: const InputDecoration(
        labelText: '店铺名称 *',
        hintText: '将根据选择的地址自动生成',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入店铺名称';
        }
        return null;
      },
    );
  }

  Widget _buildBusinessTypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedBusinessType,
      decoration: const InputDecoration(
        labelText: '主营方向 *',
        border: OutlineInputBorder(),
      ),
      items: _businessTypes.map((type) => DropdownMenuItem(
        value: type['value'],
        child: Text(type['label']!),
      )).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedBusinessType = value;
          });
        }
      },
    );
  }

  Widget _buildRegistrationNumberField() {
    return TextFormField(
      controller: _registrationNumberController,
      decoration: const InputDecoration(
        labelText: '营业执照号 *',
        hintText: '请输入营业执照注册号',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入营业执照号';
        }
        return null;
      },
    );
  }

  Widget _buildTaxIdField() {
    return TextFormField(
      controller: _taxIdController,
      decoration: const InputDecoration(
        labelText: '税务登记号',
        hintText: '请输入税务登记号（可选）',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: '联系邮箱 *',
        hintText: '请输入联系邮箱',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入联系邮箱';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return '请输入有效的邮箱地址';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
        labelText: '联系电话 *',
        hintText: '已自动获取您的电话',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入联系电话';
        }
        return null;
      },
    );
  }

  Widget _buildAddressSelector() {
    return AddressSelectorWidget(
      onAddressSelected: (province, city, district) {
        setState(() {
          _selectedProvince = province;
          _selectedCity = city;
          _selectedDistrict = district;
          _updateBusinessName();
        });
      },
    );
  }

  Widget _buildDetailAddressField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: '详细地址 *',
        hintText: '请输入具体的街道、门牌号等',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入详细地址';
        }
        return null;
      },
      onChanged: (value) {
        _detailAddress = value;
      },
    );
  }

  Widget _buildSubmitButton() {
    final applicationState = ref.watch(merchantApplicationProvider);

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: applicationState.isLoading ? null : _onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: applicationState.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('提交申请'),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProvince.isEmpty || _selectedCity.isEmpty || _selectedDistrict.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请选择完整的地址信息'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authState = ref.read(authStateProvider);
    if (authState.user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请先登录'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final applicationData = {
      'userId': authState.user!.id,
      'businessName': _businessNameController.text,
      'businessType': _selectedBusinessType,
      'registrationNumber': _registrationNumberController.text,
      'taxId': _taxIdController.text.isNotEmpty ? _taxIdController.text : 'TEMP_TAX_${DateTime.now().millisecondsSinceEpoch}',
      'contact': {
        'email': _emailController.text,
        'phone': _phoneController.text,
      },
      'address': {
        'line1': _detailAddress,
        'city': _selectedCity,
        'state': _selectedProvince,
        'postalCode': '000000',
        'country': 'China',
      },
      'businessProfile': {
        'description': '${_businessTypes.firstWhere((type) => type['value'] == _selectedBusinessType)['label']}营养餐饮服务',
        'isFranchise': true,
        'franchiseInfo': {
          'franchiseLevel': 'basic',
        },
      },
      'verification': {
        'verificationStatus': 'pending',
      },
      'compliance': {
        'termsAgreed': true,
        'privacyPolicyAgreed': true,
        'dataProcessingAgreed': true,
        'agreementDate': DateTime.now().toIso8601String(),
      },
    };

    try {
      final success = await ref
          .read(merchantApplicationProvider.notifier)
          .submitApplication(applicationData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('申请提交成功！我们将在3-5个工作日内审核您的申请'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        final error = ref.read(merchantApplicationProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('申请提交失败：${error ?? "未知错误"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '提交失败：$e';
        
        // 处理特殊错误情况
        if (e.toString().contains('该用户已经有商家资料')) {
          errorMessage = '您已经提交过商家申请，请查看申请状态';
          // 显示友好提示后返回
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: '查看申请',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                  // 导航到申请状态页面
                  Navigator.of(context).pushNamed('/merchant/application-status');
                },
              ),
            ),
          );
          return;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}