import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/index.dart';

class NutritionistVerificationPage extends StatefulWidget {
  const NutritionistVerificationPage({Key? key}) : super(key: key);

  @override
  State<NutritionistVerificationPage> createState() => _NutritionistVerificationPageState();
}

class _NutritionistVerificationPageState extends State<NutritionistVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  
  File? _certificateImage;
  String? _uploadedImageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationStatus;
  
  @override
  void initState() {
    super.initState();
    _checkExistingVerification();
  }
  
  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
  
  // 检查用户是否已有认证申请
  Future<void> _checkExistingVerification() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (userProvider.user?.nutritionistVerificationStatus != null) {
      setState(() {
        _verificationStatus = userProvider.user!.nutritionistVerificationStatus;
      });
    }
  }
  
  // 选择证书图片
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _certificateImage = File(pickedFile.path);
        // 在实际应用中，这里应该调用API上传图片到服务器
        // 这里简化处理，假设上传成功后得到一个URL
        _uploadedImageUrl = 'https://example.com/images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }
  
  // 提交认证申请
  Future<void> _submitVerification() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_uploadedImageUrl == null && _certificateImage == null) {
      setState(() {
        _errorMessage = '请上传营养师证书';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      // 实际应用中，这里应该先调用API上传图片，然后再提交认证
      // 为简化，我们假设已经上传成功，并获得了URL
      final url = _uploadedImageUrl ?? 'https://example.com/certificates/default.jpg';
      
      final result = await userProvider.applyForNutritionistVerification(
        url,
        _descriptionController.text,
      );
      
      if (result['success']) {
        setState(() {
          _verificationStatus = 'pending';
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? '申请已提交，请等待审核')),
          );
        }
      } else {
        setState(() {
          _errorMessage = result['message'] ?? '申请失败，请稍后重试';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '发生错误: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师认证'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 认证状态显示
            _buildStatusBanner(),
            
            if (_verificationStatus == null || _verificationStatus == 'rejected')
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (_errorMessage != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    
                    const Text(
                      '请上传您的营养师资格证书',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '上传清晰的证书照片或扫描件，支持JPG、PNG格式',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // 证书上传区域
                    InkWell(
                      onTap: _isLoading ? null : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _certificateImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _certificateImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text('点击上传证书'),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    const Text(
                      '专业描述',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: '请简要描述您的专业背景、工作经验等',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入专业描述';
                        }
                        if (value.length < 10) {
                          return '描述内容太短，请至少输入10个字符';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // 提交按钮
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitVerification,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('提交认证申请'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  // 根据认证状态显示不同的横幅
  Widget _buildStatusBanner() {
    if (_verificationStatus == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '请上传您的营养师资格证书，我们将在1-3个工作日内完成审核',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }
    
    if (_verificationStatus == 'pending') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.access_time, color: Colors.amber),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '您的认证申请正在审核中，请耐心等待',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
      );
    }
    
    if (_verificationStatus == 'approved') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                '恭喜您，营养师认证已通过！您可以切换为营养师身份使用更多功能',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      );
    }
    
    if (_verificationStatus == 'rejected') {
      final userProvider = Provider.of<UserProvider>(context);
      final reason = userProvider.user?.nutritionistRejectionReason ?? '未提供拒绝理由';
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    '抱歉，您的营养师认证未通过',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '拒绝原因: $reason',
              style: TextStyle(color: Colors.red.shade700),
            ),
            const SizedBox(height: 8),
            const Text(
              '您可以修改后重新提交认证申请',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }
    
    return Container();
  }
} 