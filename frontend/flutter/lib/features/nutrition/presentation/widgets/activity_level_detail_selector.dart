import 'package:flutter/material.dart';
import '../../domain/constants/nutrition_constants.dart';

/// 活动水平详情选择器
class ActivityLevelDetailSelector extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final bool enabled;

  const ActivityLevelDetailSelector({
    Key? key,
    this.selectedValue,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '活动时长详情',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: NutritionConstants.activityLevelDetails.entries
                .map((entry) => _ActivityLevelDetailTile(
                      value: entry.key,
                      label: entry.value,
                      isSelected: selectedValue == entry.key,
                      onTap: enabled ? () => onChanged(entry.key) : null,
                      enabled: enabled,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

/// 活动水平详情选项瓦片
class _ActivityLevelDetailTile extends StatelessWidget {
  final String value;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool enabled;

  const _ActivityLevelDetailTile({
    Key? key,
    required this.value,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.enabled = true,
  }) : super(key: key);

  IconData _getIconForActivityLevel(String value) {
    switch (value) {
      case 'less_than_30min':
        return Icons.chair;
      case '30_to_60min':
        return Icons.directions_walk;
      case '1_to_2hours':
        return Icons.directions_run;
      case '2_to_3hours':
        return Icons.fitness_center;
      case 'more_than_3hours':
        return Icons.sports_gymnastics;
      case 'professional_athlete':
        return Icons.emoji_events;
      default:
        return Icons.accessibility;
    }
  }

  Color _getColorForActivityLevel(String value) {
    switch (value) {
      case 'less_than_30min':
        return Colors.grey;
      case '30_to_60min':
        return Colors.blue;
      case '1_to_2hours':
        return Colors.green;
      case '2_to_3hours':
        return Colors.orange;
      case 'more_than_3hours':
        return Colors.red;
      case 'professional_athlete':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForActivityLevel(value);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.1) : null,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[200]!,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  _getIconForActivityLevel(value),
                  color: isSelected ? Colors.white : color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: enabled
                        ? (isSelected ? color : Colors.black87)
                        : Colors.grey,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}