import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

/// 文档上传步骤 - 第五步
/// 支持多文件上传、预览和管理
class DocumentUploadStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Map<String, dynamic>> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const DocumentUploadStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<DocumentUploadStep> createState() => _DocumentUploadStepState();
}

class _DocumentUploadStepState extends State<DocumentUploadStep>
    with AutomaticKeepAliveClientMixin {
  
  List<Map<String, dynamic>> _documents = [];

  @override
  bool get wantKeepAlive => true;

  // 文档类型定义（与后端保持一致）
  static const List<Map<String, dynamic>> _documentTypes = [
    {
      'value': 'nutrition_certificate',
      'label': '营养师资格证书',
      'description': '现有的营养师或相关资格证书',
      'required': true,
      'icon': Icons.verified_user_outlined,
      'acceptedFormats': ['pdf', 'jpg', 'jpeg', 'png'],
    },
    {
      'value': 'id_card',
      'label': '身份证',
      'description': '身份证正反面照片',
      'required': false,
      'icon': Icons.credit_card_outlined,
      'acceptedFormats': ['jpg', 'jpeg', 'png'],
    },
    {
      'value': 'education_certificate',
      'label': '学历证书',
      'description': '毕业证书或学位证书',
      'required': false,
      'icon': Icons.school_outlined,
      'acceptedFormats': ['pdf', 'jpg', 'jpeg', 'png'],
    },
    {
      'value': 'training_certificate',
      'label': '培训证书',
      'description': '营养相关的培训或继续教育证书',
      'required': false,
      'icon': Icons.bookmark_border_outlined,
      'acceptedFormats': ['pdf', 'jpg', 'jpeg', 'png'],
    },
    {
      'value': 'work_certificate',
      'label': '工作证明',
      'description': '工作单位出具的在职证明或推荐信',
      'required': false,
      'icon': Icons.work_outline,
      'acceptedFormats': ['pdf', 'jpg', 'jpeg', 'png'],
    },
    {
      'value': 'other_materials',
      'label': '其他材料',
      'description': '其他有助于认证申请的相关材料',
      'required': false,
      'icon': Icons.attach_file_outlined,
      'acceptedFormats': ['pdf', 'jpg', 'jpeg', 'png'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialDocuments();
  }

  void _loadInitialDocuments() {
    _documents = List<Map<String, dynamic>>.from(widget.formData);
  }

  void _onDataChanged() {
    widget.onDataChanged('documents', {'documents': _documents});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 步骤标题和描述
            _buildStepHeader(theme),
            const SizedBox(height: 32),

            // 必需文档卡片
            _buildRequiredDocumentsCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 可选文档卡片
            _buildOptionalDocumentsCard(theme, colorScheme),
            const SizedBox(height: 24),

            // 上传的文档列表
            if (_documents.isNotEmpty) ...[
              _buildUploadedDocumentsCard(theme, colorScheme),
              const SizedBox(height: 24),
            ],

            // 上传说明
            _buildUploadInstructions(theme, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildStepHeader(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.upload_file_outlined,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '文档上传',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请上传相关证明文档，确保文件清晰可读，格式正确',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildRequiredDocumentsCard(ThemeData theme, ColorScheme colorScheme) {
    final requiredTypes = _documentTypes.where((type) => type['required'] as bool).toList();
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.priority_high,
                  color: colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '必需文档',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '以下文档为认证申请的必需材料，请务必上传',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            ...requiredTypes.map((docType) {
              return _buildDocumentTypeItem(theme, colorScheme, docType, true);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionalDocumentsCard(ThemeData theme, ColorScheme colorScheme) {
    final optionalTypes = _documentTypes.where((type) => !(type['required'] as bool)).toList();
    
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '可选文档',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '以下文档有助于提高认证通过率，建议上传',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            ...optionalTypes.map((docType) {
              return _buildDocumentTypeItem(theme, colorScheme, docType, false);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentTypeItem(
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> docType,
    bool isRequired,
  ) {
    final hasUploaded = _documents.any((doc) => doc['documentType'] == docType['value']);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: hasUploaded
            ? colorScheme.primaryContainer.withOpacity(0.3)
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasUploaded
              ? colorScheme.primary.withOpacity(0.3)
              : colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: hasUploaded
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              docType['icon'] as IconData,
              size: 20,
              color: hasUploaded
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      docType['label'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isRequired) ...[
                      const SizedBox(width: 4),
                      Text(
                        '*',
                        style: TextStyle(
                          color: colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    if (hasUploaded) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.check_circle,
                        color: colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  docType['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '支持格式：${(docType['acceptedFormats'] as List).join(', ').toUpperCase()}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => _uploadDocument(docType['value'] as String),
            icon: Icon(
              hasUploaded ? Icons.edit : Icons.upload,
              size: 18,
            ),
            label: Text(hasUploaded ? '重新上传' : '上传'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedDocumentsCard(ThemeData theme, ColorScheme colorScheme) {
    return Card(
      elevation: 0,
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_open_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '已上传文档 (${_documents.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ..._documents.map((document) {
              return _buildDocumentItem(theme, colorScheme, document);
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(
    ThemeData theme,
    ColorScheme colorScheme,
    Map<String, dynamic> document,
  ) {
    final docType = _documentTypes.firstWhere(
      (type) => type['value'] == document['documentType'],
      orElse: () => {'label': '未知文档类型', 'icon': Icons.description},
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              docType['icon'] as IconData,
              size: 20,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  docType['label'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  document['fileName'] as String? ?? '未知文件',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatFileSize(document['fileSize'] as int? ?? 0),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isImageFile(document['fileName'] as String? ?? ''))
                IconButton(
                  onPressed: () => _previewDocument(document),
                  icon: const Icon(Icons.visibility_outlined),
                  iconSize: 20,
                  tooltip: '预览',
                ),
              IconButton(
                onPressed: () => _removeDocument(document),
                icon: const Icon(Icons.delete_outline),
                iconSize: 20,
                tooltip: '删除',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUploadInstructions(ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '上传说明',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 文件大小：单个文件不超过10MB\n'
            '• 支持格式：PDF、JPG、JPEG、PNG\n'
            '• 图片要求：清晰可读，避免模糊、反光\n'
            '• 营养师资格证书为必需文档，其他文档可根据实际情况选择上传\n'
            '• 所有上传的文档将被加密存储，仅用于认证审核',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.secondary.withOpacity(0.8),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadDocument(String documentType) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        // 检查文件大小 (10MB = 10 * 1024 * 1024 bytes)
        if (file.size > 10 * 1024 * 1024) {
          _showErrorMessage('文件大小不能超过10MB');
          return;
        }

        // 移除相同类型的旧文档
        _documents.removeWhere((doc) => doc['documentType'] == documentType);

        // 添加新文档
        final document = {
          'documentType': documentType,
          'fileName': file.name,
          'fileUrl': file.path, // 本地文件路径，实际应用中需要上传到服务器
          'fileSize': file.size,
          'mimeType': _getMimeType(file.extension ?? ''),
          'uploadedAt': DateTime.now().toIso8601String(),
        };

        setState(() {
          _documents.add(document);
        });
        _onDataChanged();

        _showSuccessMessage('文档上传成功');
      }
    } catch (e) {
      _showErrorMessage('上传失败：$e');
    }
  }

  void _removeDocument(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除文档'),
        content: Text('确定要删除文档"${document['fileName']}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _documents.remove(document);
              });
              _onDataChanged();
              Navigator.pop(context);
              _showSuccessMessage('文档已删除');
            },
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _previewDocument(Map<String, dynamic> document) {
    if (_isImageFile(document['fileName'] as String)) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: Text(document['fileName'] as String),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: Image.file(
                  File(document['fileUrl'] as String),
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  bool _isImageFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png'].contains(extension);
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}