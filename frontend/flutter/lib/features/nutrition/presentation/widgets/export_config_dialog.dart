import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/export_config_model.dart';

/// 导出配置对话框
class ExportConfigDialog extends ConsumerStatefulWidget {
  final ExportConfig? initialConfig;
  final bool isMultiProfile;
  final int profileCount;

  const ExportConfigDialog({
    super.key,
    this.initialConfig,
    this.isMultiProfile = false,
    this.profileCount = 1,
  });

  @override
  ConsumerState<ExportConfigDialog> createState() => _ExportConfigDialogState();
}

class _ExportConfigDialogState extends ConsumerState<ExportConfigDialog> {
  late ExportFormat _selectedFormat;
  late bool _includeBasicInfo;
  late bool _includeHealthGoals;
  late bool _includeDietaryPreferences;
  late bool _includeProgress;
  late bool _includeDetailedConfig;
  late TextEditingController _fileNameController;

  @override
  void initState() {
    super.initState();
    
    final config = widget.initialConfig ?? ExportConfig.defaultConfig(ExportFormat.json);
    _selectedFormat = config.format;
    _includeBasicInfo = config.includeBasicInfo;
    _includeHealthGoals = config.includeHealthGoals;
    _includeDietaryPreferences = config.includeDietaryPreferences;
    _includeProgress = config.includeProgress;
    _includeDetailedConfig = config.includeDetailedConfig;
    _fileNameController = TextEditingController(text: config.customFileName ?? '');
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题栏
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.download, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '导出配置',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            // 内容区域
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 导出信息
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.isMultiProfile 
                                  ? '即将导出 ${widget.profileCount} 个营养档案'
                                  : '即将导出 1 个营养档案',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 导出格式选择
                    _buildSectionTitle(context, '📄 导出格式'),
                    const SizedBox(height: 12),
                    _buildFormatSelector(context),
                    
                    const SizedBox(height: 24),
                    
                    // 内容选择
                    _buildSectionTitle(context, '📋 导出内容'),
                    const SizedBox(height: 12),
                    _buildContentSelector(context),
                    
                    const SizedBox(height: 24),
                    
                    // 文件名自定义
                    _buildSectionTitle(context, '📂 文件名称'),
                    const SizedBox(height: 12),
                    _buildFileNameInput(context),
                    
                    const SizedBox(height: 24),
                    
                    // 预设配置
                    _buildSectionTitle(context, '⚡ 快速配置'),
                    const SizedBox(height: 12),
                    _buildPresetButtons(context),
                  ],
                ),
              ),
            ),
            
            // 底部按钮
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  // 配置预览
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '包含内容: ${_getIncludedFieldsCount()} 项',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '格式: ${_selectedFormat.displayName}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // 按钮
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('取消'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: _isConfigValid() ? _handleExport : null,
                        icon: const Icon(Icons.download),
                        label: const Text('开始导出'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFormatSelector(BuildContext context) {
    return Column(
      children: ExportFormat.values.map((format) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: RadioListTile<ExportFormat>(
            value: format,
            groupValue: _selectedFormat,
            onChanged: (value) {
              setState(() {
                _selectedFormat = value!;
              });
            },
            title: Text(
              format.displayName,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              format.description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                color: _selectedFormat == format 
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[300]!,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildContentSelector(BuildContext context) {
    return Column(
      children: [
        _buildContentOption(
          context,
          title: '基本信息',
          subtitle: '性别、年龄、身高体重等',
          value: _includeBasicInfo,
          onChanged: (value) => setState(() => _includeBasicInfo = value),
          icon: Icons.person,
        ),
        _buildContentOption(
          context,
          title: '健康目标',
          subtitle: '目标热量、健康计划等',
          value: _includeHealthGoals,
          onChanged: (value) => setState(() => _includeHealthGoals = value),
          icon: Icons.flag,
        ),
        _buildContentOption(
          context,
          title: '饮食偏好',
          subtitle: '饮食习惯、过敏信息等',
          value: _includeDietaryPreferences,
          onChanged: (value) => setState(() => _includeDietaryPreferences = value),
          icon: Icons.restaurant,
        ),
        _buildContentOption(
          context,
          title: '进度统计',
          subtitle: '能量点数、连续天数等',
          value: _includeProgress,
          onChanged: (value) => setState(() => _includeProgress = value),
          icon: Icons.trending_up,
        ),
        _buildContentOption(
          context,
          title: '详细配置',
          subtitle: '高级设置和扩展信息',
          value: _includeDetailedConfig,
          onChanged: (value) => setState(() => _includeDetailedConfig = value),
          icon: Icons.settings,
        ),
      ],
    );
  }

  Widget _buildContentOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: value,
        onChanged: (newValue) => onChanged(newValue ?? false),
        title: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildFileNameInput(BuildContext context) {
    return TextFormField(
      controller: _fileNameController,
      decoration: InputDecoration(
        hintText: '自定义文件名（可选）',
        helperText: '不填写将使用默认文件名',
        border: const OutlineInputBorder(),
        suffixText: '.${_selectedFormat.extension}',
        prefixIcon: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildPresetButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _applyMinimalPreset,
            icon: const Icon(Icons.minimize, size: 16),
            label: const Text('最小', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _applyDefaultPreset,
            icon: const Icon(Icons.tune, size: 16),
            label: const Text('标准', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _applyCompletePreset,
            icon: const Icon(Icons.all_inclusive, size: 16),
            label: const Text('完整', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ],
    );
  }

  void _applyMinimalPreset() {
    setState(() {
      _includeBasicInfo = true;
      _includeHealthGoals = false;
      _includeDietaryPreferences = false;
      _includeProgress = false;
      _includeDetailedConfig = false;
    });
  }

  void _applyDefaultPreset() {
    setState(() {
      _includeBasicInfo = true;
      _includeHealthGoals = true;
      _includeDietaryPreferences = true;
      _includeProgress = true;
      _includeDetailedConfig = false;
    });
  }

  void _applyCompletePreset() {
    setState(() {
      _includeBasicInfo = true;
      _includeHealthGoals = true;
      _includeDietaryPreferences = true;
      _includeProgress = true;
      _includeDetailedConfig = true;
    });
  }

  int _getIncludedFieldsCount() {
    int count = 0;
    if (_includeBasicInfo) count++;
    if (_includeHealthGoals) count++;
    if (_includeDietaryPreferences) count++;
    if (_includeProgress) count++;
    if (_includeDetailedConfig) count++;
    return count;
  }

  bool _isConfigValid() {
    return _getIncludedFieldsCount() > 0;
  }

  void _handleExport() {
    final config = ExportConfig(
      format: _selectedFormat,
      includeBasicInfo: _includeBasicInfo,
      includeHealthGoals: _includeHealthGoals,
      includeDietaryPreferences: _includeDietaryPreferences,
      includeProgress: _includeProgress,
      includeDetailedConfig: _includeDetailedConfig,
      customFileName: _fileNameController.text.trim().isEmpty 
          ? null 
          : _fileNameController.text.trim(),
    );
    
    Navigator.pop(context, config);
  }
}