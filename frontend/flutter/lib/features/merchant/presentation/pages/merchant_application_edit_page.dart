import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/merchant_application_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/address_selector_widget.dart';

/// 商家申请编辑页面 - 用于被拒绝的商家重新提交申请
class MerchantApplicationEditPage extends ConsumerStatefulWidget {
  final Map<String, dynamic> rejectedApplication;
  
  const MerchantApplicationEditPage({
    super.key,
    required this.rejectedApplication,
  });

  @override
  ConsumerState<MerchantApplicationEditPage> createState() => _MerchantApplicationEditPageState();
}

class _MerchantApplicationEditPageState extends ConsumerState<MerchantApplicationEditPage> {
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
    _loadExistingData();
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

  /// 加载被拒绝的申请数据
  void _loadExistingData() {
    final application = widget.rejectedApplication;
    
    setState(() {
      _businessNameController.text = application['businessName'] ?? '';
      _selectedBusinessType = application['businessType'] ?? 'restaurant';
      _registrationNumberController.text = application['registrationNumber'] ?? '';
      _taxIdController.text = application['taxId'] ?? '';
      _emailController.text = application['contact']?['email'] ?? '';
      _phoneController.text = application['contact']?['phone'] ?? '';
      // 优先使用标准的省市区字段，如果不存在则使用兼容字段
      _selectedProvince = application['address']?['province'] ?? application['address']?['state'] ?? '';
      _selectedCity = application['address']?['city'] ?? '';
      _selectedDistrict = application['address']?['district'] ?? '';
      _detailAddress = application['address']?['line1'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final applicationState = ref.watch(merchantApplicationProvider);
    final rejectionReason = widget.rejectedApplication['verification']?['rejectionReason'] ?? '未提供拒绝原因';
    final rejectionTime = widget.rejectedApplication['verification']?['verificationDate'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('修改商家申请'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: applicationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.all(16.w),
                children: [
                  // 显示拒绝原因
                  _buildRejectionReasonCard(rejectionReason, rejectionTime),
                  SizedBox(height: 24.h),
                  
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

  Widget _buildRejectionReasonCard(String reason, String? time) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[700]),
                SizedBox(width: 8.w),
                Text(
                  '审核未通过',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              '拒绝原因：$reason',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red[900],
              ),
            ),
            if (time != null) ...[
              SizedBox(height: 4.h),
              Text(
                '拒绝时间：${_formatTime(time)}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.red[700],
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Text(
              '请根据拒绝原因修改相关信息后重新提交',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey[700],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final dateTime = DateTime.parse(time);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
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
        hintText: '请输入店铺名称',
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
        hintText: '请输入联系电话',
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
      initialProvince: _selectedProvince,
      initialCity: _selectedCity,
      initialDistrict: _selectedDistrict,
      onAddressSelected: (province, city, district) {
        setState(() {
          _selectedProvince = province;
          _selectedCity = city;
          _selectedDistrict = district;
        });
      },
    );
  }

  Widget _buildDetailAddressField() {
    return TextFormField(
      initialValue: _detailAddress,
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
            : const Text('重新提交申请'),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProvince.isEmpty || _selectedCity.isEmpty) {
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

    // 构建更新数据，保留原有ID
    final applicationId = widget.rejectedApplication['id'] ?? widget.rejectedApplication['_id'];
    if (applicationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('申请ID不存在，无法更新'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updateData = {
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
        'district': _selectedDistrict,
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
        'rejectionReason': null,
        'verificationDate': null,
      },
    };

    try {
      // 使用更新API而不是创建新申请
      final success = await ref
          .read(merchantApplicationProvider.notifier)
          .updateRejectedApplication(applicationId, updateData);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('申请已重新提交！我们将在3-5个工作日内审核'),
            backgroundColor: Colors.green,
          ),
        );
        // 返回上一页并刷新状态
        Navigator.of(context).pop(true);
      } else if (mounted) {
        final error = ref.read(merchantApplicationProvider).error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提交失败：${error ?? "未知错误"}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('提交失败：$e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}