import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nutritionist_provider.dart';
import '../../domain/entities/nutritionist.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../widgets/online_status_indicator.dart';

/// 营养师详情页面（用户查看）
class NutritionistDetailPage extends ConsumerStatefulWidget {
  final String nutritionistId;

  const NutritionistDetailPage({
    Key? key,
    required this.nutritionistId,
  }) : super(key: key);

  @override
  ConsumerState<NutritionistDetailPage> createState() => _NutritionistDetailPageState();
}

class _NutritionistDetailPageState extends ConsumerState<NutritionistDetailPage> {
  @override
  void initState() {
    super.initState();
    // 加载营养师详情
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionistDetailProvider(widget.nutritionistId).notifier).loadNutritionistDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final nutritionistState = ref.watch(nutritionistDetailProvider(widget.nutritionistId));

    return Scaffold(
      body: nutritionistState.when(
        initial: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryOrange,
          ),
        ),
        loaded: (nutritionist) => _buildContent(nutritionist),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 16),
              Text(
                '加载失败',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(nutritionistDetailProvider(widget.nutritionistId).notifier).loadNutritionistDetail();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: nutritionistState.maybeWhen(
        loaded: (nutritionist) => NutritionistDetailBottomBar(
          nutritionist: nutritionist,
          onConsult: () => _startConsultation(nutritionist),
          onBookmark: () => _toggleBookmark(nutritionist),
        ),
        orElse: () => null,
      ),
    );
  }

  void _startConsultation(Nutritionist nutritionist) {
    // 检查营养师是否在线
    if (!nutritionist.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('营养师当前不在线，请稍后再试或选择预约')),
      );
      return;
    }

    // TODO: 实现支付和创建咨询订单逻辑
    // 目前直接跳转到咨询页面（实际应该先支付）
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('发起咨询'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('营养师：${nutritionist.name}'),
            const SizedBox(height: 8),
            Text('咨询费用：¥${nutritionist.consultationFee.toStringAsFixed(0)}/次'),
            const SizedBox(height: 8),
            const Text('请选择咨询方式：'),
            const SizedBox(height: 16),
            ...nutritionist.availableConsultationTypes.map((type) {
              String label;
              IconData icon;
              switch (type) {
                case ConsultationType.text:
                  label = '文字咨询';
                  icon = Icons.chat_bubble_outline;
                  break;
                case ConsultationType.voice:
                  label = '语音咨询';
                  icon = Icons.phone;
                  break;
                case ConsultationType.video:
                  label = '视频咨询';
                  icon = Icons.videocam;
                  break;
                default:
                  label = type.displayName;
                  icon = Icons.help_outline;
              }
              
              return ListTile(
                leading: Icon(icon),
                title: Text(label),
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: 根据类型创建咨询
                  _createConsultation(nutritionist, type);
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }

  void _createConsultation(Nutritionist nutritionist, ConsultationType consultationType) {
    // TODO: 实现创建咨询的逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正在创建${consultationType.displayName}...'),
      ),
    );
    
    // 模拟创建成功后跳转到咨询页面
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(
        context,
        '/consultation/chat',
        arguments: {
          'nutritionistId': nutritionist.id,
          'nutritionistName': nutritionist.name,
          'consultationType': consultationType.name,
        },
      );
    });
  }

  void _toggleBookmark(Nutritionist nutritionist) {
    // TODO: 实现收藏功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('收藏功能开发中')),
    );
  }

  Widget _buildContent(Nutritionist nutritionist) {
    return CustomScrollView(
      slivers: [
        // 顶部应用栏
        _buildSliverAppBar(nutritionist),
        
        // 内容
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 基本信息卡片
              _buildBasicInfoCard(nutritionist),
              
              const SizedBox(height: 16),
              
              // 在线状态详情卡片
              OnlineStatusCard(
                nutritionist: nutritionist,
                showLastActive: true,
                showResponseTime: true,
              ),
              
              const SizedBox(height: 16),
              
              // 专业领域
              _buildSpecialtiesSection(nutritionist),
              
              const SizedBox(height: 16),
              
              // 个人简介
              _buildBioSection(nutritionist),
              
              const SizedBox(height: 16),
              
              // 服务项目
              _buildServicesSection(nutritionist),
              
              const SizedBox(height: 16),
              
              // 资质证书
              _buildCertificatesSection(nutritionist),
              
              const SizedBox(height: 16),
              
              // 用户评价
              _buildReviewsSection(nutritionist),
              
              const SizedBox(height: 100), // 底部留白
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(Nutritionist nutritionist) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primary,
                  ],
                ),
              ),
            ),
            // 头像和基本信息
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 头像
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
                      backgroundImage: nutritionist.avatar != null
                          ? NetworkImage(nutritionist.avatar!)
                          : null,
                      child: nutritionist.avatar == null
                          ? Icon(
                              Icons.person,
                              size: 48,
                              color: AppColors.textSecondary,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 姓名和认证标识
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        nutritionist.name,
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (nutritionist.isVerified) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.verified,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  // 职称
                  Text(
                    '营养师',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.9),
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

  Widget _buildBasicInfoCard(Nutritionist nutritionist) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 评分和咨询数
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.star,
                value: nutritionist.rating.toStringAsFixed(1),
                label: '评分',
                color: Colors.amber,
              ),
              _buildStatItem(
                icon: Icons.people,
                value: '${nutritionist.reviewCount}',
                label: '咨询人次',
                color: AppColors.primary,
              ),
              _buildStatItem(
                icon: Icons.work_outline,
                value: '${nutritionist.experienceYears}年',
                label: '从业经验',
                color: Colors.blue,
              ),
            ],
          ),
          
          const Divider(height: 32),
          
          // 在线状态和咨询价格
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 使用新的在线状态指示器
              OnlineStatusIndicator(
                nutritionist: nutritionist,
                showText: true,
              ),
              RichText(
                text: TextSpan(
                  style: AppTextStyles.body,
                  children: [
                    TextSpan(
                      text: '¥${nutritionist.consultationFee.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(text: '/次'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialtiesSection(Nutritionist nutritionist) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '专业领域',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: nutritionist.specialties.map((specialty) {
              return Chip(
                label: Text(specialty.displayName),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                labelStyle: TextStyle(color: AppColors.primary),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBioSection(Nutritionist nutritionist) {
    if (nutritionist.bio == null || nutritionist.bio!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '个人简介',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            nutritionist.bio!,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(Nutritionist nutritionist) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '服务项目',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...nutritionist.availableConsultationTypes.map((type) {
            IconData icon;
            String label;
            switch (type) {
              case ConsultationType.text:
                icon = Icons.chat_bubble_outline;
                label = '文字咨询';
                break;
              case ConsultationType.voice:
                icon = Icons.phone;
                label = '语音咨询';
                break;
              case ConsultationType.video:
                icon = Icons.videocam;
                label = '视频咨询';
                break;
              case ConsultationType.offline:
                icon = Icons.place;
                label = '线下咨询';
                break;
            }
            
            return ListTile(
              leading: Icon(icon, color: AppColors.primary),
              title: Text(label),
              contentPadding: EdgeInsets.zero,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildCertificatesSection(Nutritionist nutritionist) {
    // TODO: 实现资质证书展示
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '资质证书',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '已通过平台认证',
                    style: AppTextStyles.body,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(Nutritionist nutritionist) {
    // TODO: 实现用户评价展示
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '用户评价',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: 查看更多评价
                },
                child: const Text('查看更多'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 暂时显示占位内容
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '暂无评价',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部操作栏
class NutritionistDetailBottomBar extends StatelessWidget {
  final Nutritionist nutritionist;
  final VoidCallback onConsult;
  final VoidCallback onBookmark;

  const NutritionistDetailBottomBar({
    Key? key,
    required this.nutritionist,
    required this.onConsult,
    required this.onBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // 收藏按钮
            IconButton(
              onPressed: onBookmark,
              icon: const Icon(Icons.bookmark_border),
              tooltip: '收藏',
            ),
            
            const SizedBox(width: 16),
            
            // 立即咨询按钮
            Expanded(
              child: ElevatedButton(
                onPressed: nutritionist.isOnline ? onConsult : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  nutritionist.isOnline ? '立即咨询' : '营养师离线中',
                  style: AppTextStyles.button,
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // 预约按钮
            Flexible(
              child: OutlinedButton(
                onPressed: () => _showBookingDialog(context, nutritionist),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '预约',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showBookingDialog(BuildContext context, Nutritionist nutritionist) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _BookingBottomSheet(nutritionist: nutritionist),
    );
  }
}

/// 预约底部弹窗
class _BookingBottomSheet extends StatefulWidget {
  final Nutritionist nutritionist;

  const _BookingBottomSheet({
    Key? key,
    required this.nutritionist,
  }) : super(key: key);

  @override
  State<_BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<_BookingBottomSheet> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedConsultationType;
  final _remarkController = TextEditingController();

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '预约咨询',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 营养师信息
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: widget.nutritionist.avatar != null
                        ? NetworkImage(widget.nutritionist.avatar!)
                        : null,
                    child: widget.nutritionist.avatar == null
                        ? Icon(Icons.person, color: AppColors.textSecondary)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.nutritionist.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '¥${widget.nutritionist.consultationFee.toStringAsFixed(0)}/次',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const Divider(height: 32),
              
              // 选择日期
              Text(
                '选择日期',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : '请选择日期',
                        style: AppTextStyles.body,
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 选择时间
              Text(
                '选择时间',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedTime != null
                            ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                            : '请选择时间',
                        style: AppTextStyles.body,
                      ),
                      const Icon(Icons.access_time),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 选择咨询方式
              Text(
                '咨询方式',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...widget.nutritionist.availableConsultationTypes.map((type) {
                String label;
                switch (type) {
                  case ConsultationType.text:
                    label = '文字咨询';
                    break;
                  case ConsultationType.voice:
                    label = '语音咨询';
                    break;
                  case ConsultationType.video:
                    label = '视频咨询';
                    break;
                  case ConsultationType.offline:
                    label = '线下咨询';
                    break;
                }
                
                return RadioListTile<String>(
                  title: Text(label),
                  value: type.name,
                  groupValue: _selectedConsultationType,
                  onChanged: (value) {
                    setState(() {
                      _selectedConsultationType = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
              
              const SizedBox(height: 16),
              
              // 备注
              Text(
                '备注（选填）',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _remarkController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '请输入您的健康需求或想咨询的问题',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // 确认按钮
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSubmit() ? _submitBooking : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('确认预约'),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  bool _canSubmit() {
    return _selectedDate != null &&
        _selectedTime != null &&
        _selectedConsultationType != null;
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _submitBooking() {
    // TODO: 实现预约提交逻辑
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '预约成功！已预约${widget.nutritionist.name}的咨询，'
          '时间：${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day} '
          '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}