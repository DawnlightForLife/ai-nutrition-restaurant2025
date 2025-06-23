import 'package:flutter/material.dart';

/// 认证筛选栏组件
class CertificationFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedLevel;
  final String? selectedSpecialization;
  final Function(String?) onLevelChanged;
  final Function(String?) onSpecializationChanged;
  final Function(String) onSearchChanged;

  const CertificationFilterBar({
    super.key,
    required this.searchController,
    required this.selectedLevel,
    required this.selectedSpecialization,
    required this.onLevelChanged,
    required this.onSpecializationChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // 搜索框
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: '搜索营养师姓名、ID或申请编号',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                        onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 12),

          // 筛选选项
          Row(
            children: [
              // 认证等级筛选
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedLevel,
                  decoration: InputDecoration(
                    labelText: '认证等级',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('全部等级'),
                    ),
                    DropdownMenuItem(
                      value: 'junior',
                      child: Text('初级营养师'),
                    ),
                    DropdownMenuItem(
                      value: 'intermediate',
                      child: Text('中级营养师'),
                    ),
                    DropdownMenuItem(
                      value: 'senior',
                      child: Text('高级营养师'),
                    ),
                    DropdownMenuItem(
                      value: 'expert',
                      child: Text('专家营养师'),
                    ),
                  ],
                  onChanged: onLevelChanged,
                ),
              ),
              const SizedBox(width: 12),

              // 专业领域筛选
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedSpecialization,
                  decoration: InputDecoration(
                    labelText: '专业领域',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: null,
                      child: Text('全部领域'),
                    ),
                    DropdownMenuItem(
                      value: 'clinical',
                      child: Text('临床营养'),
                    ),
                    DropdownMenuItem(
                      value: 'sports',
                      child: Text('运动营养'),
                    ),
                    DropdownMenuItem(
                      value: 'child',
                      child: Text('儿童营养'),
                    ),
                    DropdownMenuItem(
                      value: 'elderly',
                      child: Text('老年营养'),
                    ),
                    DropdownMenuItem(
                      value: 'weight',
                      child: Text('体重管理'),
                    ),
                    DropdownMenuItem(
                      value: 'disease',
                      child: Text('疾病营养'),
                    ),
                  ],
                  onChanged: onSpecializationChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}