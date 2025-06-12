import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/merchant_application_provider.dart';

/// 商家申请页面
class MerchantApplicationPage extends ConsumerStatefulWidget {
  const MerchantApplicationPage({super.key});

  @override
  ConsumerState<MerchantApplicationPage> createState() => _MerchantApplicationPageState();
}

class _MerchantApplicationPageState extends ConsumerState<MerchantApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _taxIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _websiteController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedBusinessType = 'restaurant';
  int? _establishmentYear;

  @override
  void dispose() {
    _businessNameController.dispose();
    _businessTypeController.dispose();
    _registrationNumberController.dispose();
    _taxIdController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _descriptionController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
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
                  SizedBox(height: 16.h),
                  _buildWebsiteField(),
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('商家简介'),
                  _buildDescriptionField(),
                  SizedBox(height: 16.h),
                  _buildEstablishmentYearField(),
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle('地址信息'),
                  _buildAddressLine1Field(),
                  SizedBox(height: 16.h),
                  _buildAddressLine2Field(),
                  SizedBox(height: 16.h),
                  _buildCityField(),
                  SizedBox(height: 16.h),
                  _buildStateField(),
                  SizedBox(height: 16.h),
                  _buildPostalCodeField(),
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
        labelText: '商家类型 *',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'restaurant', child: Text('餐厅')),
        DropdownMenuItem(value: 'cafe', child: Text('咖啡店')),
        DropdownMenuItem(value: 'bakery', child: Text('烘焙店')),
        DropdownMenuItem(value: 'food_truck', child: Text('流动餐车')),
        DropdownMenuItem(value: 'catering', child: Text('餐饮服务')),
        DropdownMenuItem(value: 'other', child: Text('其他')),
      ],
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

  Widget _buildWebsiteField() {
    return TextFormField(
      controller: _websiteController,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
        labelText: '网站地址',
        hintText: '请输入网站地址（可选）',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: '商家简介 *',
        hintText: '请简要介绍您的商家特色、服务理念等',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入商家简介';
        }
        return null;
      },
    );
  }

  Widget _buildEstablishmentYearField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: '成立年份',
        hintText: '请输入成立年份（可选）',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          _establishmentYear = int.tryParse(value);
        } else {
          _establishmentYear = null;
        }
      },
    );
  }

  Widget _buildAddressLine1Field() {
    return TextFormField(
      controller: _addressLine1Controller,
      decoration: const InputDecoration(
        labelText: '详细地址 *',
        hintText: '请输入详细地址',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入详细地址';
        }
        return null;
      },
    );
  }

  Widget _buildAddressLine2Field() {
    return TextFormField(
      controller: _addressLine2Controller,
      decoration: const InputDecoration(
        labelText: '补充地址',
        hintText: '楼层、房间号等（可选）',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      decoration: const InputDecoration(
        labelText: '城市 *',
        hintText: '请输入城市',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入城市';
        }
        return null;
      },
    );
  }

  Widget _buildStateField() {
    return TextFormField(
      controller: _stateController,
      decoration: const InputDecoration(
        labelText: '省份 *',
        hintText: '请输入省份',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入省份';
        }
        return null;
      },
    );
  }

  Widget _buildPostalCodeField() {
    return TextFormField(
      controller: _postalCodeController,
      decoration: const InputDecoration(
        labelText: '邮政编码 *',
        hintText: '请输入邮政编码',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入邮政编码';
        }
        return null;
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

    final applicationData = {
      'businessName': _businessNameController.text,
      'businessType': _selectedBusinessType,
      'registrationNumber': _registrationNumberController.text,
      'taxId': _taxIdController.text.isEmpty ? null : _taxIdController.text,
      'contact': {
        'email': _emailController.text,
        'phone': _phoneController.text,
        'website': _websiteController.text.isEmpty ? null : _websiteController.text,
      },
      'address': {
        'line1': _addressLine1Controller.text,
        'line2': _addressLine2Controller.text.isEmpty ? null : _addressLine2Controller.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'postalCode': _postalCodeController.text,
        'country': 'China',
      },
      'businessProfile': {
        'description': _descriptionController.text,
        'establishmentYear': _establishmentYear,
        'cuisineTypes': <String>[], // 可以后续扩展
        'facilities': <String>[], // 可以后续扩展
      },
      'nutritionFeatures': {
        'hasNutritionist': false,
        'nutritionCertified': false,
      },
    };

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
  }
}