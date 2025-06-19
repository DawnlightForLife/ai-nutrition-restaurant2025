import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/inventory_provider.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryFormPage extends ConsumerStatefulWidget {
  final String merchantId;
  final String? inventoryId; // null for create, inventoryId for edit

  const InventoryFormPage({
    Key? key,
    required this.merchantId,
    this.inventoryId,
  }) : super(key: key);

  @override
  ConsumerState<InventoryFormPage> createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends ConsumerState<InventoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _minThresholdController;
  
  String _selectedUnit = 'kg';
  String _selectedCategory = 'ingredient';
  
  // 预警设置
  bool _lowStockAlert = true;
  bool _expiryAlert = true;
  bool _qualityAlert = true;
  int _expiryWarningDays = 3;
  double _lowStockRatio = 0.2;

  final List<String> _units = ['kg', 'g', 'L', 'ml', '个', '包', '盒', '袋'];
  final List<Map<String, String>> _categories = [
    {'value': 'ingredient', 'label': '食材'},
    {'value': 'spice', 'label': '调料'},
    {'value': 'beverage', 'label': '饮料'},
    {'value': 'packaging', 'label': '包装'},
    {'value': 'other', 'label': '其他'},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _minThresholdController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minThresholdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(inventoryFormProvider);
    final isEditing = widget.inventoryId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? '编辑库存项目' : '添加库存项目'),
        actions: [
          TextButton(
            onPressed: formState.isSubmitting ? null : _saveInventory,
            child: Text(
              formState.isSubmitting ? '保存中...' : '保存',
              style: TextStyle(
                color: formState.isSubmitting ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 基本信息
            _buildBasicInfoSection(),
            
            const SizedBox(height: 24),
            
            // 库存设置
            _buildStockSettingsSection(),
            
            const SizedBox(height: 24),
            
            // 预警设置
            _buildAlertSettingsSection(),
            
            const SizedBox(height: 32),
            
            // 保存按钮
            _buildSaveButton(),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
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
            
            // 项目名称
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '项目名称 *',
                hintText: '请输入库存项目名称',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入项目名称';
                }
                return null;
              },
              onChanged: (value) {
                ref.read(inventoryFormProvider.notifier).updateForm(name: value);
              },
            ),
            
            const SizedBox(height: 16),
            
            // 单位和分类
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: '计量单位',
                      border: OutlineInputBorder(),
                    ),
                    items: _units.map((unit) {
                      return DropdownMenuItem(
                        value: unit,
                        child: Text(unit),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedUnit = value;
                        });
                        ref.read(inventoryFormProvider.notifier).updateForm(unit: value);
                      }
                    },
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: '项目分类',
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category['value'],
                        child: Text(category['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        ref.read(inventoryFormProvider.notifier).updateForm(category: value);
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

  Widget _buildStockSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '库存设置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 最低库存阈值
            TextFormField(
              controller: _minThresholdController,
              decoration: InputDecoration(
                labelText: '最低库存阈值 *',
                hintText: '0.0',
                border: const OutlineInputBorder(),
                suffixText: _selectedUnit,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return '请输入最低库存阈值';
                }
                final threshold = double.tryParse(value);
                if (threshold == null || threshold < 0) {
                  return '请输入有效的阈值';
                }
                return null;
              },
              onChanged: (value) {
                final threshold = double.tryParse(value);
                if (threshold != null) {
                  ref.read(inventoryFormProvider.notifier).updateForm(minThreshold: threshold);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '预警设置',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            
            // 低库存预警
            SwitchListTile(
              title: const Text('低库存预警'),
              subtitle: const Text('当库存低于阈值时发送预警'),
              value: _lowStockAlert,
              onChanged: (value) {
                setState(() {
                  _lowStockAlert = value;
                });
                _updateAlertSettings();
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            // 过期预警
            SwitchListTile(
              title: const Text('过期预警'),
              subtitle: const Text('当库存即将过期时发送预警'),
              value: _expiryAlert,
              onChanged: (value) {
                setState(() {
                  _expiryAlert = value;
                });
                _updateAlertSettings();
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            // 质量预警
            SwitchListTile(
              title: const Text('质量预警'),
              subtitle: const Text('当检测到质量问题时发送预警'),
              value: _qualityAlert,
              onChanged: (value) {
                setState(() {
                  _qualityAlert = value;
                });
                _updateAlertSettings();
              },
              contentPadding: EdgeInsets.zero,
            ),
            
            const SizedBox(height: 16),
            
            // 过期预警天数
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('过期预警天数'),
                ),
                Expanded(
                  child: Slider(
                    value: _expiryWarningDays.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    label: '$_expiryWarningDays天',
                    onChanged: _expiryAlert ? (value) {
                      setState(() {
                        _expiryWarningDays = value.round();
                      });
                      _updateAlertSettings();
                    } : null,
                  ),
                ),
                Text('$_expiryWarningDays天'),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // 低库存比例
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text('低库存比例'),
                ),
                Expanded(
                  child: Slider(
                    value: _lowStockRatio,
                    min: 0.1,
                    max: 0.5,
                    divisions: 8,
                    label: '${(_lowStockRatio * 100).round()}%',
                    onChanged: _lowStockAlert ? (value) {
                      setState(() {
                        _lowStockRatio = value;
                      });
                      _updateAlertSettings();
                    } : null,
                  ),
                ),
                Text('${(_lowStockRatio * 100).round()}%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    final formState = ref.watch(inventoryFormProvider);
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: formState.isSubmitting ? null : _saveInventory,
        child: formState.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(widget.inventoryId != null ? '更新库存项目' : '创建库存项目'),
      ),
    );
  }

  void _updateAlertSettings() {
    final alertSettings = AlertSettings(
      lowStockAlert: _lowStockAlert,
      expiryAlert: _expiryAlert,
      qualityAlert: _qualityAlert,
      expiryWarningDays: _expiryWarningDays,
      lowStockRatio: _lowStockRatio,
    );
    
    ref.read(inventoryFormProvider.notifier).updateForm(alertSettings: alertSettings);
  }

  Future<void> _saveInventory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(inventoryFormProvider.notifier)
        .submitForm();

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('保存失败: ${failure.message}'),
            backgroundColor: Colors.red,
          ),
        );
      },
      (inventory) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.inventoryId != null ? '库存项目更新成功' : '库存项目创建成功'),
            backgroundColor: Colors.green,
          ),
        );
        
        // 清空表单状态
        ref.read(inventoryFormProvider.notifier).resetForm();
        
        // 返回列表页面
        context.pop();
      },
    );
  }
}