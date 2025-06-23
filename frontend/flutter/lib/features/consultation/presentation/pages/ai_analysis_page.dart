import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/consultation_provider.dart';
import '../widgets/food_analysis_result.dart';
import '../widgets/nutrition_recommendations.dart';

class AIAnalysisPage extends ConsumerStatefulWidget {
  const AIAnalysisPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AIAnalysisPage> createState() => _AIAnalysisPageState();
}

class _AIAnalysisPageState extends ConsumerState<AIAnalysisPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  File? _selectedImage;
  final TextEditingController _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final analysisState = ref.watch(aiAnalysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI营养分析'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(
              icon: Icon(Icons.camera_alt),
              text: '食物分析',
            ),
            Tab(
              icon: Icon(Icons.psychology),
              text: '智能推荐',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // 食物分析页面
          _buildFoodAnalysisTab(analysisState),
          
          // 智能推荐页面  
          _buildRecommendationsTab(analysisState),
        ],
      ),
    );
  }

  Widget _buildFoodAnalysisTab(AsyncValue<Map<String, dynamic>> analysisState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 图片选择区域
          _buildImageSelectionArea(),
          
          const SizedBox(height: 16),
          
          // 描述输入
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: '食物描述（可选）',
              hintText: '描述一下这道菜的做法、配料等信息...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 分析按钮
          ElevatedButton(
            onPressed: _selectedImage != null && !analysisState.isLoading
                ? _analyzeFood
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: analysisState.isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('分析中...'),
                    ],
                  )
                : const Text(
                    '开始AI分析',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
          
          const SizedBox(height: 24),
          
          // 分析结果
          analysisState.when(
            data: (data) => data.isNotEmpty 
                ? FoodAnalysisResult(analysisData: data)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red[400],
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '分析失败',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab(AsyncValue<Map<String, dynamic>> analysisState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 健康数据输入卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '个人健康数据',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 简化的健康数据输入表单
                  _buildHealthDataForm(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 获取推荐按钮
          ElevatedButton(
            onPressed: !analysisState.isLoading ? _getRecommendations : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: analysisState.isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('生成中...'),
                    ],
                  )
                : const Text(
                    '获取AI推荐',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
          
          const SizedBox(height: 24),
          
          // 推荐结果
          analysisState.when(
            data: (data) => data.containsKey('recommendations') 
                ? NutritionRecommendations(recommendationsData: data)
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red[400],
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '获取推荐失败',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: Colors.red[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSelectionArea() {
    return Card(
      child: InkWell(
        onTap: _pickImage,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[300]!,
              style: BorderStyle.solid,
            ),
          ),
          child: _selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '点击选择食物照片',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '支持JPG、PNG格式',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHealthDataForm() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: '年龄',
                  suffixText: '岁',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: '性别',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'male', child: Text('男')),
                  DropdownMenuItem(value: 'female', child: Text('女')),
                ],
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: '身高',
                  suffixText: 'cm',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: '体重',
                  suffixText: 'kg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '活动水平',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'sedentary', child: Text('久坐少动')),
            DropdownMenuItem(value: 'light', child: Text('轻度活动')),
            DropdownMenuItem(value: 'moderate', child: Text('中度活动')),
            DropdownMenuItem(value: 'active', child: Text('高度活动')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _analyzeFood() {
    if (_selectedImage == null) return;

    // 这里需要先上传图片获取URL，然后调用AI分析
    // 简化实现，假设我们有图片URL
    final imageUrl = 'path/to/uploaded/image.jpg';
    
    ref.read(aiAnalysisProvider.notifier).analyzeFood(
      imageUrl: imageUrl,
      description: _descriptionController.text.isNotEmpty 
          ? _descriptionController.text 
          : null,
    );
  }

  void _getRecommendations() {
    // 收集健康数据
    final healthData = {
      'age': 25,
      'gender': 'female',
      'height': 165,
      'weight': 55,
      'activityLevel': 'moderate',
    };
    
    final goals = ['weight_loss', 'health_improvement'];
    
    ref.read(aiAnalysisProvider.notifier).getAIRecommendations(
      userId: 'current_user_id', // 从auth状态获取
      healthData: healthData,
      goals: goals,
    );
  }
}