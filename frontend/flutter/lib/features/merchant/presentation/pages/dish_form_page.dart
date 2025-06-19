import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../providers/dish_provider.dart';
import '../widgets/dish_image_picker.dart';
import '../widgets/nutrition_facts_form.dart';
import '../widgets/ingredient_selector.dart';
import '../../domain/entities/dish_entity.dart';
import '../../domain/entities/ingredient_entity.dart';

class DishFormPage extends ConsumerStatefulWidget {
  final String merchantId;
  final String? dishId; // null for create, dishId for edit

  const DishFormPage({
    Key? key,
    required this.merchantId,
    this.dishId,
  }) : super(key: key);

  @override
  ConsumerState<DishFormPage> createState() => _DishFormPageState();
}

class _DishFormPageState extends ConsumerState<DishFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _prepTimeController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _prepTimeController = TextEditingController();
    
    // 如果是编辑模式，加载菜品数据
    if (widget.dishId != null) {
      _loadDishForEdit();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _prepTimeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadDishForEdit() async {
    if (widget.dishId == null) return;
    
    setState(() => _isLoading = true);
    
    final dishAsync = ref.read(dishProvider(widget.dishId!));
    dishAsync.whenData((dish) {
      if (dish != null) {
        ref.read(dishFormProvider.notifier).loadDishForEdit(dish);
        _populateForm(dish);
      }
    });
    
    setState(() => _isLoading = false);
  }

  void _populateForm(DishEntity dish) {
    _nameController.text = dish.name;
    _descriptionController.text = dish.description;
    _priceController.text = dish.price.toString();
    _prepTimeController.text = dish.estimatedPrepTime.toString();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(dishFormProvider);
    final isEditing = widget.dishId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑菜品' : '新建菜品'),
        actions: [
          TextButton(
            onPressed: formState.isSubmitting ? null : _saveDish,
            child: Text(
              formState.isSubmitting ? '保存中...' : '保存',
              style: TextStyle(
                color: formState.isSubmitting ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // 菜品图片
                  _buildImageSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 基本信息
                  _buildBasicInfoSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 分类和标签
                  _buildCategorySection(),
                  
                  const SizedBox(height: 24),
                  
                  // 营养信息
                  _buildNutritionSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 配料信息
                  _buildIngredientsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 过敏原和饮食限制
                  _buildAllergensSection(),
                  
                  const SizedBox(height: 24),
                  
                  // 其他设置
                  _buildSettingsSection(),
                  
                  const SizedBox(height: 32),
                  
                  // 保存按钮
                  _buildSaveButton(),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '菜品图片',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            DishImagePicker(
              dishId: widget.dishId,
              onImagesChanged: (images) {
                // Handle image changes
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final formState = ref.watch(dishFormProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '基本信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 菜品名称
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '菜品名称 *',
                hintText: '请输入菜品名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入菜品名称';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(dishFormProvider.notifier).updateForm(name: value);
              },
            ),
            
            const SizedBox(height: 16),
            
            // 菜品描述
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '菜品描述 *',
                hintText: '请输入菜品描述',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入菜品描述';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(dishFormProvider.notifier).updateForm(description: value);
              },
            ),
            
            const SizedBox(height: 16),
            
            // 价格和制作时间
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: '价格 (￥) *',
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                      prefixText: '￥ ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入价格';
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 0) {
                        return '请输入有效价格';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final price = double.tryParse(value);
                      if (price != null) {
                        ref.read(dishFormProvider.notifier).updateForm(price: price);
                      }
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: TextFormField(
                    controller: _prepTimeController,
                    decoration: const InputDecoration(
                      labelText: '制作时间 (分钟)',
                      hintText: '30',
                      border: OutlineInputBorder(),
                      suffixText: '分钟',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final time = int.tryParse(value);
                      if (time != null) {
                        ref.read(dishFormProvider.notifier).updateForm(estimatedPrepTime: time);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    final formState = ref.watch(dishFormProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '分类和标签',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 分类选择
            DropdownButtonFormField<DishCategory>(
              value: DishCategory.values.firstWhere(
                (cat) => cat.value == formState.category,
                orElse: () => DishCategory.mainCourse,
              ),
              decoration: const InputDecoration(
                labelText: '菜品分类',
                border: OutlineInputBorder(),
              ),
              items: DishCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.displayName),
                );
              }).toList(),
              onChanged: (category) {
                if (category != null) {
                  ref.read(dishFormProvider.notifier).updateForm(category: category.value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // 辣度选择
            DropdownButtonFormField<SpicyLevel>(
              value: formState.spicyLevel,
              decoration: const InputDecoration(
                labelText: '辣度',
                border: OutlineInputBorder(),
              ),
              items: SpicyLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Row(
                    children: [
                      if (level != SpicyLevel.none)
                        Icon(
                          Icons.local_fire_department,
                          size: 16,
                          color: _getSpicyColor(level),
                        ),
                      if (level != SpicyLevel.none) const SizedBox(width: 8),
                      Text(level.displayName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (level) {
                if (level != null) {
                  ref.read(dishFormProvider.notifier).updateForm(spicyLevel: level);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '营养信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            NutritionFactsForm(
              onNutritionChanged: (nutritionFacts) {
                ref.read(dishFormProvider.notifier).updateForm(nutritionFacts: nutritionFacts);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    final formState = ref.watch(dishFormProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '配料信息',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            IngredientSelector(
              initialIngredients: formState.ingredients.map((e) => e.name).toList(),
              onIngredientsChanged: (ingredients) {
                // 将字符串列表转换为IngredientUsageEntity列表
                final ingredientEntities = ingredients.map((name) => 
                  IngredientUsageEntity(
                    ingredientId: name, // 暂时使用名称作为ID
                    name: name,
                    quantity: 0,
                    unit: '',
                  )
                ).toList();
                ref.read(dishFormProvider.notifier).updateForm(ingredients: ingredientEntities);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllergensSection() {
    final formState = ref.watch(dishFormProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '过敏原和饮食限制',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 这里可以添加过敏原和饮食限制的选择器
            // 暂时用简单的文本提示
            Text(
              '过敏原: ${formState.allergens.join(', ')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              '饮食限制: ${formState.dietaryRestrictions.join(', ')}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final formState = ref.watch(dishFormProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '其他设置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            SwitchListTile(
              title: const Text('可用状态'),
              subtitle: const Text('是否在菜单中显示'),
              value: formState.isAvailable,
              onChanged: (value) {
                ref.read(dishFormProvider.notifier).updateForm(isAvailable: value);
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            SwitchListTile(
              title: const Text('特色菜品'),
              subtitle: const Text('标记为招牌菜'),
              value: formState.isFeatured,
              onChanged: (value) {
                ref.read(dishFormProvider.notifier).updateForm(isFeatured: value);
              },
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final formState = ref.watch(dishFormProvider);
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: formState.isSubmitting ? null : _saveDish,
        child: formState.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(widget.dishId != null ? '更新菜品' : '创建菜品'),
      ),
    );
  }

  Color _getSpicyColor(SpicyLevel level) {
    switch (level) {
      case SpicyLevel.mild:
        return Colors.orange[300]!;
      case SpicyLevel.medium:
        return Colors.orange[600]!;
      case SpicyLevel.hot:
        return Colors.red[600]!;
      case SpicyLevel.veryHot:
        return Colors.red[800]!;
      default:
        return Colors.grey;
    }
  }

  Future<void> _saveDish() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(dishFormProvider.notifier)
        .submitForm(widget.merchantId);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (dish) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.dishId != null ? '菜品更新成功' : '菜品创建成功'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 清空表单状态
        ref.read(dishFormProvider.notifier).resetForm();
        
        // 返回列表页面
        Navigator.of(context).pop();
      },
    );
  }
}