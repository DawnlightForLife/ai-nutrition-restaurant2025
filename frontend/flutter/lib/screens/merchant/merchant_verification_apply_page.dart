import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class MerchantVerificationApplyPage extends StatefulWidget {
  const MerchantVerificationApplyPage({super.key});

  @override
  State<MerchantVerificationApplyPage> createState() => _MerchantVerificationApplyPageState();
}

class _MerchantVerificationApplyPageState extends State<MerchantVerificationApplyPage> {
  final _formKey = GlobalKey<FormState>();
  final _businessLicenseController = TextEditingController();
  final _addressController = TextEditingController();
  final _businessTypeController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _businessLicenseController.dispose();
    _addressController.dispose();
    _businessTypeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: 调用后端API提交认证申请
      await Future.delayed(const Duration(seconds: 1)); // 模拟API调用
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('认证申请已提交，请等待审核'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
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
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('商家认证申请'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '商家认证信息',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _businessLicenseController,
                        decoration: const InputDecoration(
                          labelText: '营业执照号',
                          hintText: '请输入营业执照号',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入营业执照号';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: '经营地址',
                          hintText: '请输入详细的经营地址',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入经营地址';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _businessTypeController,
                        decoration: const InputDecoration(
                          labelText: '经营类型',
                          hintText: '例如：中餐厅、西餐厅、快餐店等',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入经营类型';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: '商家简介',
                          hintText: '请简要描述您的商家特色',
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '请输入商家简介';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitVerification,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('提交认证申请'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 