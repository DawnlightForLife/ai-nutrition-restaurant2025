import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../system/presentation/providers/system_config_provider.dart';
import '../../../system/domain/entities/system_config.dart';

/// 系统配置管理页面（管理后台）
class SystemConfigPage extends ConsumerStatefulWidget {
  const SystemConfigPage({super.key});

  @override
  ConsumerState<SystemConfigPage> createState() => _SystemConfigPageState();
}

class _SystemConfigPageState extends ConsumerState<SystemConfigPage> {
  String? _selectedCategory;
  
  @override
  void initState() {
    super.initState();
    // 加载所有配置
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(systemConfigManagerProvider.notifier).loadAllConfigs();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final configsAsync = ref.watch(systemConfigManagerProvider);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('系统配置管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(systemConfigManagerProvider.notifier).loadAllConfigs(
                category: _selectedCategory,
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (category) {
              setState(() {
                _selectedCategory = category == 'all' ? null : category;
              });
              ref.read(systemConfigManagerProvider.notifier).loadAllConfigs(
                category: _selectedCategory,
              );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Text('全部'),
              ),
              const PopupMenuItem(
                value: 'feature',
                child: Text('功能配置'),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Text('系统配置'),
              ),
              const PopupMenuItem(
                value: 'business',
                child: Text('业务配置'),
              ),
              const PopupMenuItem(
                value: 'ui',
                child: Text('界面配置'),
              ),
              const PopupMenuItem(
                value: 'security',
                child: Text('安全配置'),
              ),
            ],
          ),
        ],
      ),
      body: configsAsync.when(
        data: (configs) {
          if (configs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings_suggest,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '暂无配置项',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      await ref.read(systemConfigManagerProvider.notifier).initializeDefaults();
                    },
                    child: const Text('初始化默认配置'),
                  ),
                ],
              ),
            );
          }
          
          // 特殊处理认证功能配置
          final certConfigs = configs.where((config) => 
            config.key.contains('certification') && !config.key.contains('contact')
          ).toList();
          
          // 特殊处理联系信息配置
          final contactConfigs = configs.where((config) => 
            config.key.contains('certification_contact')
          ).toList();
          
          final otherConfigs = configs.where((config) => 
            !config.key.contains('certification')
          ).toList();
          
          return ListView(
            children: [
              // 认证功能配置卡片
              if (certConfigs.isNotEmpty) ...[
                _buildCertificationCard(certConfigs),
                const Divider(height: 32),
              ],
              
              // 联系信息配置卡片
              if (contactConfigs.isNotEmpty || certConfigs.isNotEmpty) ...[
                _buildContactConfigCard(contactConfigs),
                const Divider(height: 32),
              ],
              
              // 其他配置列表
              ...otherConfigs.map((config) => _buildConfigItem(config)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '加载失败',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref.read(systemConfigManagerProvider.notifier).loadAllConfigs();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// 构建认证功能配置卡片
  Widget _buildCertificationCard(List<SystemConfig> configs) {
    final theme = Theme.of(context);
    
    // 获取商家认证配置
    final merchantEnabled = _getConfigValue(configs, CertificationConfigKeys.merchantCertificationEnabled) == 'true';
    final merchantMode = _getConfigValue(configs, CertificationConfigKeys.merchantCertificationMode) ?? 'contact';
    
    // 获取营养师认证配置
    final nutritionistEnabled = _getConfigValue(configs, CertificationConfigKeys.nutritionistCertificationEnabled) == 'true';
    final nutritionistMode = _getConfigValue(configs, CertificationConfigKeys.nutritionistCertificationMode) ?? 'contact';
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '认证功能配置',
                  style: theme.textTheme.titleLarge,
                ),
                const Spacer(),
                // 添加刷新按钮
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    ref.read(systemConfigManagerProvider.notifier).loadAllConfigs();
                  },
                  tooltip: '刷新配置',
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 商家认证配置
            _buildCertificationSection(
              title: '商家认证',
              icon: Icons.store,
              enabled: merchantEnabled,
              mode: merchantMode,
              onEnabledChanged: (value) async {
                await _updateCertificationConfig(
                  CertificationConfigKeys.merchantCertificationEnabled,
                  value,
                );
              },
              onModeChanged: (value) async {
                if (value != null) {
                  await _updateCertificationConfig(
                    CertificationConfigKeys.merchantCertificationMode,
                    value,
                  );
                }
              },
            ),
            
            const Divider(height: 32),
            
            // 营养师认证配置
            _buildCertificationSection(
              title: '营养师认证',
              icon: Icons.health_and_safety,
              enabled: nutritionistEnabled,
              mode: nutritionistMode,
              onEnabledChanged: (value) async {
                await _updateCertificationConfig(
                  CertificationConfigKeys.nutritionistCertificationEnabled,
                  value,
                );
              },
              onModeChanged: (value) async {
                if (value != null) {
                  await _updateCertificationConfig(
                    CertificationConfigKeys.nutritionistCertificationMode,
                    value,
                  );
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // 添加说明信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '开启认证功能后，用户可以在个人中心申请相应的认证。认证模式可以选择"联系客服"或"自动认证"。',
                      style: theme.textTheme.bodySmall,
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
  
  /// 构建认证配置部分
  Widget _buildCertificationSection({
    required String title,
    required IconData icon,
    required bool enabled,
    required String mode,
    required ValueChanged<bool> onEnabledChanged,
    required ValueChanged<String?> onModeChanged,
  }) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.titleMedium,
            ),
            const Spacer(),
            // 状态标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: enabled 
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                enabled ? '已启用' : '已禁用',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: enabled 
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onErrorContainer,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 开关按钮
            Switch(
              value: enabled,
              onChanged: onEnabledChanged,
            ),
          ],
        ),
        if (enabled) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '认证模式',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('联系客服'),
                        selected: mode == 'contact',
                        onSelected: (selected) {
                          if (selected) onModeChanged('contact');
                        },
                        avatar: const Icon(Icons.support_agent, size: 16),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('自动认证'),
                        selected: mode == 'auto',
                        onSelected: (selected) {
                          if (selected) onModeChanged('auto');
                        },
                        avatar: const Icon(Icons.auto_awesome, size: 16),
                      ),
                    ),
                  ],
                ),
                if (mode == 'contact') ...[
                  const SizedBox(height: 8),
                  Text(
                    '用户需要联系客服完成认证',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 8),
                  Text(
                    '系统将自动审核用户的认证申请',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 快速认证配置
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.speed,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '快速认证配置',
                              style: theme.textTheme.titleSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // 快速认证开关
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '启用快速认证',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            Switch(
                              value: _getConfigValue(
                                ref.read(systemConfigManagerProvider).value ?? [],
                                '${title == '商家认证' ? 'merchant' : 'nutritionist'}_quick_certification_enabled'
                              ) == 'true',
                              onChanged: (value) async {
                                await _updateCertificationConfig(
                                  '${title == '商家认证' ? 'merchant' : 'nutritionist'}_quick_certification_enabled',
                                  value,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // 快速认证阈值
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '快速认证阈值',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                controller: TextEditingController(
                                  text: _getConfigValue(
                                    ref.read(systemConfigManagerProvider).value ?? [],
                                    '${title == '商家认证' ? 'merchant' : 'nutritionist'}_quick_certification_threshold'
                                  ) ?? '80',
                                ),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  suffixText: '%',
                                ),
                                onChanged: (value) async {
                                  if (value.isNotEmpty) {
                                    final numValue = int.tryParse(value);
                                    if (numValue != null && numValue >= 0 && numValue <= 100) {
                                      await _updateCertificationConfig(
                                        '${title == '商家认证' ? 'merchant' : 'nutritionist'}_quick_certification_threshold',
                                        numValue,
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '当用户满足条件时，系统将自动通过认证申请',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  /// 构建单个配置项
  Widget _buildConfigItem(SystemConfig config) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(
        _getConfigIcon(config.category),
        color: theme.colorScheme.primary,
      ),
      title: Text(config.description),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            config.key,
            style: theme.textTheme.bodySmall?.copyWith(
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Chip(
                label: Text(config.category.name),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: 8),
              if (config.isPublic)
                const Chip(
                  label: Text('公开'),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
            ],
          ),
        ],
      ),
      trailing: _buildConfigValueWidget(config),
      onTap: config.isEditable ? () => _editConfig(config) : null,
    );
  }
  
  /// 构建配置值显示组件
  Widget _buildConfigValueWidget(SystemConfig config) {
    switch (config.valueType) {
      case ConfigValueType.boolean:
        return Switch(
          value: config.getBoolValue(),
          onChanged: config.isEditable 
            ? (value) => _updateConfig(config.key, value)
            : null,
        );
      
      case ConfigValueType.number:
        return Text(
          config.getNumberValue().toString(),
          style: const TextStyle(fontFamily: 'monospace'),
        );
      
      case ConfigValueType.string:
        return SizedBox(
          width: 100,
          child: Text(
            config.getStringValue(),
            style: const TextStyle(fontFamily: 'monospace'),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        );
      
      case ConfigValueType.json:
      case ConfigValueType.array:
        return const Icon(Icons.code);
    }
  }
  
  /// 获取配置图标
  IconData _getConfigIcon(ConfigCategory category) {
    switch (category) {
      case ConfigCategory.feature:
        return Icons.toggle_on;
      case ConfigCategory.system:
        return Icons.settings_applications;
      case ConfigCategory.business:
        return Icons.business_center;
      case ConfigCategory.ui:
        return Icons.design_services;
      case ConfigCategory.security:
        return Icons.security;
    }
  }
  
  /// 更新配置
  Future<void> _updateConfig(String key, dynamic value) async {
    try {
      await ref.read(systemConfigManagerProvider.notifier).updateConfig(key, value);
      
      // 如果是认证相关配置，刷新认证配置状态
      if (key.contains('certification')) {
        ref.read(certificationConfigProvider.notifier).refreshConfigs();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('配置更新成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('更新失败: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
  
  /// 更新认证配置
  Future<void> _updateCertificationConfig(String key, dynamic value) async {
    await _updateConfig(key, value);
  }
  
  /// 编辑配置
  Future<void> _editConfig(SystemConfig config) async {
    // TODO: 显示编辑对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('配置编辑功能即将上线')),
    );
  }
  
  /// 构建联系信息配置卡片
  Widget _buildContactConfigCard(List<SystemConfig> contactConfigs) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.qr_code,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '认证联系信息配置',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '配置用户申请认证时显示的客服联系方式',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            
            // 微信客服配置
            _buildContactConfigItem(
              icon: Icons.chat,
              title: '客服微信',
              key: 'certification_contact_wechat',
              currentValue: _getConfigValue(contactConfigs, 'certification_contact_wechat') ?? 'AIHealth2025',
              hint: '请输入客服微信号',
              onSave: (value) => _updateOrCreateConfig(
                'certification_contact_wechat',
                value,
                '认证客服微信号',
              ),
            ),
            
            const Divider(),
            
            // 客服电话配置
            _buildContactConfigItem(
              icon: Icons.phone,
              title: '客服电话',
              key: 'certification_contact_phone',
              currentValue: _getConfigValue(contactConfigs, 'certification_contact_phone') ?? '400-123-4567',
              hint: '请输入客服电话',
              onSave: (value) => _updateOrCreateConfig(
                'certification_contact_phone',
                value,
                '认证客服电话',
              ),
            ),
            
            const Divider(),
            
            // 客服邮箱配置
            _buildContactConfigItem(
              icon: Icons.email,
              title: '客服邮箱',
              key: 'certification_contact_email',
              currentValue: _getConfigValue(contactConfigs, 'certification_contact_email') ?? 'cert@aihealth.com',
              hint: '请输入客服邮箱',
              onSave: (value) => _updateOrCreateConfig(
                'certification_contact_email',
                value,
                '认证客服邮箱',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // 提示信息
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '修改联系信息后，用户申请认证时将看到更新后的联系方式',
                      style: theme.textTheme.bodySmall,
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
  
  /// 构建联系信息配置项
  Widget _buildContactConfigItem({
    required IconData icon,
    required String title,
    required String key,
    required String currentValue,
    required String hint,
    required Future<void> Function(String) onSave,
  }) {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: currentValue);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hint,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () async {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                await onSave(value);
              }
            },
            icon: const Icon(Icons.save, size: 16),
            label: const Text('保存'),
          ),
        ],
      ),
    );
  }
  
  /// 获取配置值
  String? _getConfigValue(List<SystemConfig> configs, String key) {
    try {
      final config = configs.firstWhere((c) => c.key == key);
      return config.getStringValue();
    } catch (e) {
      return null;
    }
  }
  
  /// 更新或创建配置
  Future<void> _updateOrCreateConfig(String key, String value, String description) async {
    try {
      // 尝试更新配置
      await ref.read(systemConfigManagerProvider.notifier).updateConfig(key, value);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('配置更新成功')),
        );
      }
    } catch (e) {
      // 如果更新失败，可能是配置不存在，尝试创建
      try {
        final newConfig = SystemConfig(
          key: key,
          value: value,
          valueType: ConfigValueType.string,
          category: ConfigCategory.business,
          description: description,
          isPublic: true,
          isEditable: true,
        );
        
        await ref.read(systemConfigManagerProvider.notifier).createConfig(newConfig);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('配置创建成功')),
          );
        }
      } catch (createError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('操作失败: $createError'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}