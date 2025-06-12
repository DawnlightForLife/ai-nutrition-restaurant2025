import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

/// 文档验证步骤 - 第三步
/// 上传必要的证明文件：学历证书 + 工作证明（可选）
class DocumentVerificationStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Map<String, dynamic>> formData;
  final void Function(String section, Map<String, dynamic> data) onDataChanged;

  const DocumentVerificationStep({
    Key? key,
    required this.formKey,
    required this.formData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<DocumentVerificationStep> createState() => _DocumentVerificationStepState();
}

class _DocumentVerificationStepState extends State<DocumentVerificationStep>
    with AutomaticKeepAliveClientMixin {
  
  List<Map<String, dynamic>> _documents = [];

  // 必需文档类型
  static const List<Map<String, dynamic>> _requiredDocuments = [
    {
      'type': 'education_certificate',
      'name': '学历证书',
      'description': '毕业证书或学位证书',
      'required': true,
      'icon': Icons.school,
    },
    {
      'type': 'work_certificate',
      'name': '工作证明',
      'description': '在职证明或劳动合同（可选）',
      'required': false,
      'icon': Icons.work,
    },
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _documents = List.from(widget.formData);
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

            // 文档上传列表
            ..._requiredDocuments.map((docType) => 
              _buildDocumentUploadCard(docType, theme, colorScheme)
            ).toList(),

            const SizedBox(height: 24),

            // 说明提示
            _buildInfoTips(theme, colorScheme),
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
              '文档验证',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '请上传相关证明文件以完成资质验证',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentUploadCard(
    Map<String, dynamic> docType, 
    ThemeData theme, 
    ColorScheme colorScheme
  ) {
    final uploadedDoc = _documents.firstWhere(
      (doc) => doc['documentType'] == docType['type'],
      orElse: () => <String, dynamic>{},
    );
    final isUploaded = uploadedDoc.isNotEmpty;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isUploaded 
              ? colorScheme.primary.withOpacity(0.5)
              : colorScheme.outline.withOpacity(0.2),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? colorScheme.primaryContainer
                        : colorScheme.secondaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    docType['icon'] as IconData,
                    color: isUploaded
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSecondaryContainer.withOpacity(0.7),
                    size: 20,
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
                            docType['name'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (docType['required'] == true) ...[
                            const SizedBox(width: 4),
                            Text(
                              '*',
                              style: TextStyle(color: colorScheme.error),
                            ),
                          ],
                          if (isUploaded) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '已上传',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        docType['description'] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (isUploaded) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.description,
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            uploadedDoc['fileName']?.toString() ?? '未知文件',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(uploadedDoc['fileSize'] ?? 0) ~/ 1024} KB',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: colorScheme.error,
                      ),
                      onPressed: () => _removeDocument(docType['type']?.toString() ?? ''),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 上传按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _uploadDocument(docType['type']?.toString() ?? ''),
                icon: Icon(
                  isUploaded ? Icons.refresh : Icons.upload_file,
                ),
                label: Text(isUploaded ? '重新上传' : '选择文件'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTips(ThemeData theme, ColorScheme colorScheme) {
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
                Icons.info_outline,
                color: colorScheme.secondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '上传要求',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '• 支持格式：JPG、PNG、PDF\n'
            '• 文件大小：不超过5MB\n'
            '• 请确保文件清晰完整，便于审核\n'
            '• 学历证书为必需文件，工作证明可选',
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
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final now = DateTime.now();

        // 检查文件大小 (5MB限制)
        if ((file.size) > 5 * 1024 * 1024) {
          _showSnackBar('文件大小不能超过5MB', isError: true);
          return;
        }

        final documentData = {
          'documentType': documentType,
          'fileName': file.name,
          'fileUrl': file.path,
          'fileSize': file.size,
          'mimeType': _getMimeType(file.extension ?? ''),
          'uploadedAt': now.toIso8601String(),
        };

        setState(() {
          // 移除旧文档（如果存在）
          _documents.removeWhere((doc) => doc['documentType'] == documentType);
          // 添加新文档
          _documents.add(documentData);
        });

        widget.onDataChanged('documents', {'documents': _documents});
        _showSnackBar('文件上传成功');
      }
    } catch (e) {
      _showSnackBar('文件上传失败：$e', isError: true);
    }
  }

  void _removeDocument(String documentType) {
    setState(() {
      _documents.removeWhere((doc) => doc['documentType'] == documentType);
    });
    widget.onDataChanged('documents', {'documents': _documents});
    _showSnackBar('文件已删除');
  }

  String _getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError 
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}