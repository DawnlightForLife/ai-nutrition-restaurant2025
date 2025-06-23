import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/nutritionist.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import 'online_status_indicator.dart';

class NutritionistCard extends StatelessWidget {
  final Nutritionist nutritionist;
  final VoidCallback? onTap;
  final VoidCallback? onBookConsultation;

  const NutritionistCard({
    Key? key,
    required this.nutritionist,
    this.onTap,
    this.onBookConsultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头部：头像、姓名、状态
              Row(
                children: [
                  // 头像
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: nutritionist.avatar != null
                          ? CachedNetworkImage(
                              imageUrl: nutritionist.avatar!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.background,
                              child: const Icon(
                                Icons.person,
                                color: AppColors.textSecondary,
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 姓名和基本信息
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              nutritionist.name,
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(width: 8),
                            if (nutritionist.isVerified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 12,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '已认证',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            const Spacer(),
                            // 在线状态指示器
                            OnlineStatusIndicator(
                              nutritionist: nutritionist,
                              showText: false,
                              size: 8.0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, 
                                vertical: 2.0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            if (nutritionist.rating > 0) ...[
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                nutritionist.ratingText,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              '${nutritionist.reviewCount}次咨询',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              nutritionist.experienceText,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // 状态指示器
                  _buildStatusIndicator(),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 专业领域
              if (nutritionist.specialties.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: nutritionist.specialties.take(3).map((specialty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primaryLight.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          specialty.displayName,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              
              const SizedBox(height: 12),
              
              // 简介
              if (nutritionist.bio != null && nutritionist.bio!.isNotEmpty)
                Text(
                  nutritionist.bio!,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              
              const SizedBox(height: 12),
              
              // 底部：价格和预约按钮
              Row(
                children: [
                  Text(
                    nutritionist.priceText,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 咨询类型图标
                  if (nutritionist.availableConsultationTypes.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: nutritionist.availableConsultationTypes.take(3).map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            type.icon,
                            style: const TextStyle(fontSize: 16),
                          ),
                        );
                      }).toList(),
                    ),
                  
                  const SizedBox(width: 12),
                  
                  // 预约按钮
                  Flexible(
                    child: ElevatedButton(
                      onPressed: nutritionist.canBook ? onBookConsultation : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: Text(
                        nutritionist.canBook ? '立即咨询' : '暂不可预约',
                        style: AppTextStyles.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color statusColor;
    String statusText;
    
    if (!nutritionist.isVerified) {
      statusColor = AppColors.textSecondary;
      statusText = '未认证';
    } else if (!nutritionist.isOnline) {
      statusColor = AppColors.warning;
      statusText = '离线';
    } else {
      statusColor = AppColors.success;
      statusText = '在线';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            statusText,
            style: AppTextStyles.caption.copyWith(
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}