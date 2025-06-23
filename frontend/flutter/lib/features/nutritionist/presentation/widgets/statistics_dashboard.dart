import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/workbench_provider.dart';
import '../../domain/models/workbench_models.dart';

/// 营养师统计仪表板
class StatisticsDashboard extends ConsumerWidget {
  const StatisticsDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return statsAsync.when(
      data: (stats) => _buildDashboard(context, stats),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text('加载失败: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(dashboardStatsProvider),
              child: const Text('重试'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 总体统计卡片
          _buildOverallStats(context, stats.overall),
          const SizedBox(height: 24),

          // 今日统计
          Text(
            '今日数据',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildTodayStats(context, stats.today),
          const SizedBox(height: 24),

          // 趋势图表
          Text(
            '最近趋势',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildTrendsChart(context, stats.recentTrends),
          const SizedBox(height: 24),

          // 即将进行的咨询
          if (stats.upcomingConsultations.isNotEmpty) ...[
            Text(
              '即将进行的咨询',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildUpcomingConsultations(context, stats.upcomingConsultations),
          ],
        ],
      ),
    );
  }

  Widget _buildOverallStats(BuildContext context, OverallStats overall) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '总体表现',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.chat,
                    label: '总咨询数',
                    value: overall.totalConsultations.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.people,
                    label: '服务客户',
                    value: overall.totalClients.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.star,
                    label: '平均评分',
                    value: overall.averageRating.toStringAsFixed(1),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    icon: Icons.attach_money,
                    label: '总收入',
                    value: '¥${overall.totalRevenue.toStringAsFixed(2)}',
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(BuildContext context, TodayStats today) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildTodayStatCard(
          context,
          title: '今日咨询',
          value: today.consultations.toString(),
          icon: Icons.chat_bubble,
          color: Colors.blue,
        ),
        _buildTodayStatCard(
          context,
          title: '已完成',
          value: today.completedConsultations.toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        _buildTodayStatCard(
          context,
          title: '新客户',
          value: today.newClients.toString(),
          icon: Icons.person_add,
          color: Colors.orange,
        ),
        _buildTodayStatCard(
          context,
          title: '今日收入',
          value: '¥${today.totalIncome.toStringAsFixed(2)}',
          icon: Icons.monetization_on,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }

  Widget _buildTodayStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart(BuildContext context, Map<String, dynamic> trends) {
    // Convert trends data to chart data
    final List<FlSpot> spots = [];
    final List<String> labels = [];
    
    if (trends.isNotEmpty) {
      // Assuming trends contains daily data for the last 7 days
      trends.forEach((key, value) {
        if (value is num) {
          spots.add(FlSpot(spots.length.toDouble(), value.toDouble()));
          labels.add(key);
        }
      });
    }

    // If no data, create sample data
    if (spots.isEmpty) {
      for (int i = 0; i < 7; i++) {
        spots.add(FlSpot(i.toDouble(), 5.0 + i * 2));
        labels.add('Day ${i + 1}');
      }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '咨询量趋势',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 5,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.withOpacity(0.2),
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < labels.length) {
                            return Text(
                              labels[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.withOpacity(0.2)),
                      left: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 0,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingConsultations(
    BuildContext context,
    List<UpcomingConsultation> consultations,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...consultations.take(5).map((consultation) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(
                    (consultation.username ?? '用户').substring(0, 1),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                title: Text(consultation.username ?? '用户'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consultation.topic ?? '咨询',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (consultation.appointmentTime != null)
                      Text(
                        _formatAppointmentTime(consultation.appointmentTime!),
                        style: const TextStyle(fontSize: 12),
                      ),
                  ],
                ),
                trailing: _buildStatusChip(consultation.status),
              );
            }).toList(),
            if (consultations.length > 5) ...[
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to full consultation list
                  },
                  child: Text('查看全部 (${consultations.length})'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    Color color;
    String label;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        label = '待处理';
        break;
      case 'active':
        color = Colors.blue;
        label = '进行中';
        break;
      case 'scheduled':
        color = Colors.green;
        label = '已安排';
        break;
      default:
        color = Colors.grey;
        label = status ?? '未知';
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _formatAppointmentTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);

    if (difference.isNegative) {
      return '已过期';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟后';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}小时后';
    } else {
      return '${time.month}月${time.day}日 ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }
}