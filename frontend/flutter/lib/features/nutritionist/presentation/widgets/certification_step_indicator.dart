import 'package:flutter/material.dart';

/// 认证步骤指示器 - Material 3 设计
/// 支持点击导航、动画效果和丰富的视觉反馈
class CertificationStepIndicator extends StatefulWidget {
  final int currentStep;
  final int totalSteps;
  final List<Map<String, String>> stepInfo;
  final bool Function(int) onStepTapped;

  const CertificationStepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepInfo,
    required this.onStepTapped,
  }) : super(key: key);

  @override
  State<CertificationStepIndicator> createState() => _CertificationStepIndicatorState();
}

class _CertificationStepIndicatorState extends State<CertificationStepIndicator>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      height: 100,
      child: Row(
        children: List.generate(widget.totalSteps, (index) {
          return Expanded(
            child: _buildStepItem(
              context,
              index,
              widget.stepInfo[index],
              colorScheme,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepItem(
    BuildContext context,
    int index,
    Map<String, String> stepInfo,
    ColorScheme colorScheme,
  ) {
    final isActive = index == widget.currentStep;
    final isCompleted = index < widget.currentStep;
    final isAccessible = widget.onStepTapped(index);
    
    return GestureDetector(
      onTap: isAccessible ? () => _handleStepTap(index) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Column(
          children: [
            // 步骤圆圈和连接线
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  // 左边的连接线
                  if (index > 0)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        decoration: BoxDecoration(
                          color: isCompleted || (isActive && index > 0)
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                  
                  // 步骤圆圈
                  AnimatedScale(
                    scale: isActive ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getStepColor(isCompleted, isActive, colorScheme),
                        border: Border.all(
                          color: _getStepBorderColor(isCompleted, isActive, colorScheme),
                          width: 2,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: colorScheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: _buildStepIcon(
                          stepInfo['icon']!,
                          isCompleted,
                          isActive,
                          colorScheme,
                          index,
                        ),
                      ),
                    ),
                  ),
                  
                  // 右边的连接线
                  if (index < widget.totalSteps - 1)
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 2,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? colorScheme.primary
                              : colorScheme.outline.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // 步骤标题
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                color: _getTextColor(isCompleted, isActive, colorScheme),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(
                stepInfo['title']!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // 步骤描述（仅在当前步骤显示）
            if (isActive)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: AnimatedOpacity(
                  opacity: isActive ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    stepInfo['description']!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepIcon(
    String iconName,
    bool isCompleted,
    bool isActive,
    ColorScheme colorScheme,
    int index,
  ) {
    if (isCompleted) {
      return Icon(
        Icons.check,
        color: colorScheme.onPrimary,
        size: 20,
      );
    }

    final iconColor = isActive
        ? colorScheme.onPrimary
        : colorScheme.onSurface.withOpacity(0.6);

    switch (iconName) {
      case 'person':
        return Icon(Icons.person_outline, color: iconColor, size: 20);
      case 'school':
        return Icon(Icons.school_outlined, color: iconColor, size: 20);
      case 'work':
        return Icon(Icons.work_outline, color: iconColor, size: 20);
      case 'verified':
        return Icon(Icons.verified_outlined, color: iconColor, size: 20);
      case 'upload_file':
        return Icon(Icons.upload_file_outlined, color: iconColor, size: 20);
      default:
        return Text(
          '${index + 1}',
          style: TextStyle(
            color: iconColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        );
    }
  }

  Color _getStepColor(bool isCompleted, bool isActive, ColorScheme colorScheme) {
    if (isCompleted) return colorScheme.primary;
    if (isActive) return colorScheme.primary;
    return colorScheme.surface;
  }

  Color _getStepBorderColor(bool isCompleted, bool isActive, ColorScheme colorScheme) {
    if (isCompleted || isActive) return colorScheme.primary;
    return colorScheme.outline.withOpacity(0.5);
  }

  Color _getTextColor(bool isCompleted, bool isActive, ColorScheme colorScheme) {
    if (isCompleted) return colorScheme.primary;
    if (isActive) return colorScheme.primary;
    return colorScheme.onSurface.withOpacity(0.6);
  }

  void _handleStepTap(int index) {
    if (widget.onStepTapped(index)) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
      // TODO: 实现步骤跳转逻辑
    }
  }
}