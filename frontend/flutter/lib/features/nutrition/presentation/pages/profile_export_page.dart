import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../data/services/profile_export_service.dart';
import '../providers/nutrition_profile_list_provider.dart';

class ProfileExportPage extends ConsumerStatefulWidget {
  final List<NutritionProfileV2>? selectedProfiles;

  const ProfileExportPage({
    super.key,
    this.selectedProfiles,
  });

  @override
  ConsumerState<ProfileExportPage> createState() => _ProfileExportPageState();
}

class _ProfileExportPageState extends ConsumerState<ProfileExportPage> {
  final ProfileExportService _exportService = ProfileExportService();
  
  List<NutritionProfileV2> _selectedProfiles = [];
  ExportFormat _selectedFormat = ExportFormat.json;
  bool _isExporting = false;
  List<ExportFileInfo> _exportedFiles = [];
  
  @override
  void initState() {
    super.initState();
    _loadSelectedProfiles();
    _loadExportedFiles();
  }

  void _loadSelectedProfiles() {
    if (widget.selectedProfiles != null) {
      _selectedProfiles = List.from(widget.selectedProfiles!);
    } else {
      // 如果没有预选档案，加载所有档案
      final profileListState = ref.read(nutritionProfileListProvider);
      _selectedProfiles = List.from(profileListState.profiles);
    }
  }

  Future<void> _loadExportedFiles() async {
    final files = await _exportService.getExportedFiles();
    if (mounted) {
      setState(() {
        _exportedFiles = files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('导出营养档案'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSelectionSection(theme),
            const SizedBox(height: 24),
            _buildFormatSelectionSection(theme),
            const SizedBox(height: 24),
            _buildExportSection(theme),
            const SizedBox(height: 32),
            _buildExportedFilesSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSelectionSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '选择导出档案',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '已选择 ${_selectedProfiles.length} 个档案',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            
            // 全选/取消全选
            Row(
              children: [
                TextButton.icon(
                  onPressed: _selectAllProfiles,
                  icon: const Icon(Icons.select_all),
                  label: const Text('全选'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _clearSelection,
                  icon: const Icon(Icons.clear),
                  label: const Text('清空'),
                ),
              ],
            ),
            
            // 档案列表
            if (_getAllProfiles().isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _getAllProfiles().length,
                  itemBuilder: (context, index) {
                    final profile = _getAllProfiles()[index];
                    final isSelected = _selectedProfiles.contains(profile);
                    
                    return CheckboxListTile(
                      value: isSelected,
                      onChanged: (selected) => _toggleProfileSelection(profile),
                      title: Text(profile.profileName),
                      subtitle: Text(
                        '${profile.completionPercentage}% 完整 · '
                        '${_formatDate(profile.updatedAt)}',
                      ),
                      dense: true,
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelectionSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.file_download,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '选择导出格式',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            _buildFormatOption(
              format: ExportFormat.json,
              title: 'JSON 格式',
              description: '结构化数据，适合程序处理和数据备份',
              icon: Icons.code,
            ),
            const SizedBox(height: 8),
            
            _buildFormatOption(
              format: ExportFormat.csv,
              title: 'CSV 格式',
              description: '表格数据，可用 Excel 等软件打开',
              icon: Icons.table_chart,
            ),
            const SizedBox(height: 8),
            
            _buildFormatOption(
              format: ExportFormat.text,
              title: '文本格式',
              description: '可读性强，适合打印和阅读',
              icon: Icons.text_snippet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatOption({
    required ExportFormat format,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return RadioListTile<ExportFormat>(
      value: format,
      groupValue: _selectedFormat,
      onChanged: (value) {
        setState(() {
          _selectedFormat = value!;
        });
      },
      title: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      subtitle: Text(description),
      dense: true,
    );
  }

  Widget _buildExportSection(ThemeData theme) {
    final canExport = _selectedProfiles.isNotEmpty && !_isExporting;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.upload,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '开始导出',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: canExport ? _exportProfiles : null,
                icon: _isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(_isExporting ? '导出中...' : '导出档案'),
              ),
            ),
            
            if (!canExport && !_isExporting) ...[
              const SizedBox(height: 8),
              Text(
                '请至少选择一个档案进行导出',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExportedFilesSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  '导出历史',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_exportedFiles.isNotEmpty)
                  TextButton(
                    onPressed: _clearAllFiles,
                    child: const Text('清空全部'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_exportedFiles.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '暂无导出文件',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _exportedFiles.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final file = _exportedFiles[index];
                  return _buildFileItem(file, theme);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileItem(ExportFileInfo file, ThemeData theme) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.primaryContainer,
        child: Text(
          file.formatText,
          style: TextStyle(
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        file.filename,
        style: const TextStyle(fontSize: 14),
      ),
      subtitle: Text(
        '${file.fileSizeText} · ${_formatDate(file.createdAt)}',
        style: theme.textTheme.bodySmall,
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (action) => _handleFileAction(action, file),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'share',
            child: ListTile(
              leading: Icon(Icons.share),
              title: Text('分享'),
              dense: true,
            ),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('删除', style: TextStyle(color: Colors.red)),
              dense: true,
            ),
          ),
        ],
      ),
    );
  }

  List<NutritionProfileV2> _getAllProfiles() {
    final profileListState = ref.watch(nutritionProfileListProvider);
    return profileListState.profiles;
  }

  void _toggleProfileSelection(NutritionProfileV2 profile) {
    setState(() {
      if (_selectedProfiles.contains(profile)) {
        _selectedProfiles.remove(profile);
      } else {
        _selectedProfiles.add(profile);
      }
    });
  }

  void _selectAllProfiles() {
    setState(() {
      _selectedProfiles = List.from(_getAllProfiles());
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedProfiles.clear();
    });
  }

  Future<void> _exportProfiles() async {
    if (_selectedProfiles.isEmpty) return;
    
    setState(() {
      _isExporting = true;
    });
    
    try {
      ExportResult result;
      
      switch (_selectedFormat) {
        case ExportFormat.json:
          result = await _exportService.exportToJson(_selectedProfiles);
          break;
        case ExportFormat.csv:
          result = await _exportService.exportToCsv(_selectedProfiles);
          break;
        case ExportFormat.text:
          result = await _exportService.exportToText(_selectedProfiles);
          break;
        default:
          throw Exception('不支持的导出格式');
      }
      
      if (result.isSuccess) {
        await _loadExportedFiles(); // 刷新文件列表
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('导出成功：${result.filename}'),
              action: SnackBarAction(
                label: '分享',
                onPressed: () => _shareFile(result),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.error ?? '导出失败'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('导出失败：$e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isExporting = false;
      });
    }
  }

  Future<void> _shareFile(ExportResult result) async {
    final shareResult = await _exportService.shareExportedFile(result);
    if (!shareResult.isSuccess && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(shareResult.error ?? '分享失败')),
      );
    }
  }

  Future<void> _handleFileAction(String action, ExportFileInfo file) async {
    switch (action) {
      case 'share':
        final result = ExportResult.success(
          filePath: file.filePath,
          filename: file.filename,
          format: file.format,
          fileSize: file.fileSize,
        );
        await _shareFile(result);
        break;
      case 'delete':
        final deleted = await _exportService.deleteExportedFile(file.filePath);
        if (deleted) {
          await _loadExportedFiles();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('已删除 ${file.filename}')),
            );
          }
        }
        break;
    }
  }

  Future<void> _clearAllFiles() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空所有文件'),
        content: const Text('确定要删除所有导出文件吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final deletedCount = await _exportService.clearAllExportedFiles();
      await _loadExportedFiles();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已删除 $deletedCount 个文件')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }
}