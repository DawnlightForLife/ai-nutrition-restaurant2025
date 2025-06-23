import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/nutritionist_management_provider.dart';
import '../../domain/entities/nutritionist_management_entity.dart';
import '../../../nutritionist/presentation/providers/nutritionist_status_provider.dart';

class NutritionistManagementStats extends ConsumerWidget {
  const NutritionistManagementStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionistManagementProvider);
    final onlineCount = ref.watch(onlineNutritionistsCountProvider);
    final availableCount = ref.watch(availableNutritionistsCountProvider);

    if (state.overview == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在加载统计数据...'),
          ],
        ),
      );
    }

    final overview = state.overview!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 概览卡片
          _buildOverviewCards(context, overview.overview),
          
          const SizedBox(height: 24),
          
          // 状态分布图表
          _buildStatusDistributionChart(context, overview.distributions.status),
          
          const SizedBox(height: 24),
          
          // 专业领域分布图表
          _buildSpecializationChart(context, overview.distributions.specialization),
          
          const SizedBox(height: 24),
          
          // 认证等级分布
          _buildLevelDistributionChart(context, overview.distributions.level),
          
          const SizedBox(height: 24),
          
          // 注册趋势图表
          _buildRegistrationTrendChart(context, overview.trends.registration),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(BuildContext context, OverviewStats overview) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '营养师概览',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // 第一行统计卡片
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: '总营养师数',
                value: '${overview.totalNutritionists}',
                icon: Icons.people,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                title: '活跃营养师',
                value: '${overview.activeNutritionists}',
                icon: Icons.person_add,
                color: Colors.green,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 第二行统计卡片
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: '实时在线',
                value: '$onlineCount',
                icon: Icons.online_prediction,
                color: Colors.orange,
                subtitle: '数据库记录: ${overview.onlineNutritionists}',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                title: '待审核',
                value: '${overview.pendingVerification}',
                icon: Icons.pending,
                color: Colors.red,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 第三行统计卡片 - 实时可用营养师
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                title: '实时可用',
                value: '$availableCount',
                icon: Icons.check_circle,
                color: Colors.green,
                subtitle: '在线且可接咨询',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                title: '可用率',
                value: onlineCount > 0 ? '${((availableCount / onlineCount) * 100).toStringAsFixed(1)}%' : '0%',
                icon: Icons.trending_up,
                color: Colors.purple,
                subtitle: '可用/在线比例',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // 活跃度指标
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.purple),
                  const SizedBox(width: 8),
                  const Text(
                    '月度活跃度',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '本月活跃: ${overview.activeInMonth} 位营养师',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 4),
              Text(
                '活跃率: ${overview.activityRate}%',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusDistributionChart(
    BuildContext context,
    List<StatusDistribution> statusData,
  ) {
    if (statusData.isEmpty) return const SizedBox.shrink();

    return _buildChartContainer(
      context,
      title: '营养师状态分布',
      icon: Icons.pie_chart,
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: statusData.map((data) {
              return PieChartSectionData(
                value: data.count.toDouble(),
                color: _getStatusColor(data.id),
                title: '${data.count}',
                radius: 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
            centerSpaceRadius: 40,
            sectionsSpace: 2,
          ),
        ),
      ),
      legend: Column(
        children: statusData.map((data) {
          return _buildLegendItem(
            _getStatusColor(data.id),
            _getStatusName(data.id),
            data.count,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSpecializationChart(
    BuildContext context,
    List<SpecializationDistribution> specializationData,
  ) {
    if (specializationData.isEmpty) return const SizedBox.shrink();

    return _buildChartContainer(
      context,
      title: '专业领域分布（Top 10）',
      icon: Icons.bar_chart,
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: specializationData
                .map((e) => e.count.toDouble())
                .reduce((a, b) => a > b ? a : b) * 1.2,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < specializationData.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Text(
                            _getSpecializationName(specializationData[index].id),
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: specializationData.asMap().entries.map((entry) {
              return BarChartGroupData(
                x: entry.key,
                barRods: [
                  BarChartRodData(
                    toY: entry.value.count.toDouble(),
                    color: Colors.blue.withOpacity(0.8),
                    width: 20,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelDistributionChart(
    BuildContext context,
    List<LevelDistribution> levelData,
  ) {
    if (levelData.isEmpty) return const SizedBox.shrink();

    return _buildChartContainer(
      context,
      title: '认证等级分布',
      icon: Icons.star,
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: levelData.map((data) {
              return PieChartSectionData(
                value: data.count.toDouble(),
                color: _getLevelColor(data.id),
                title: '${data.count}',
                radius: 60,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList(),
            centerSpaceRadius: 30,
            sectionsSpace: 2,
          ),
        ),
      ),
      legend: Column(
        children: levelData.map((data) {
          return _buildLegendItem(
            _getLevelColor(data.id),
            _getLevelName(data.id),
            data.count,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRegistrationTrendChart(
    BuildContext context,
    List<RegistrationTrend> trendData,
  ) {
    if (trendData.isEmpty) return const SizedBox.shrink();

    return _buildChartContainer(
      context,
      title: '近7天注册趋势',
      icon: Icons.trending_up,
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < trendData.length) {
                      final trend = trendData[index];
                      return Text(
                        '${trend.id.month}/${trend.id.day}',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: trendData.asMap().entries.map((entry) {
                  return FlSpot(
                    entry.key.toDouble(),
                    entry.value.count.toDouble(),
                  );
                }).toList(),
                isCurved: true,
                color: Colors.blue,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.blue.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContainer(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget child,
    Widget? legend,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          if (legend != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: child),
                const SizedBox(width: 16),
                Expanded(flex: 1, child: legend),
              ],
            )
          else
            child,
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return Colors.red;
      case 'pendingVerification':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  String _getStatusName(String status) {
    switch (status) {
      case 'active':
        return '活跃';
      case 'inactive':
        return '不活跃';
      case 'suspended':
        return '已暂停';
      case 'pendingVerification':
        return '待审核';
      default:
        return status;
    }
  }

  String _getSpecializationName(String specialization) {
    const names = {
      'clinical': '临床营养',
      'sports': '运动营养',
      'pediatric': '儿童营养',
      'geriatric': '老年营养',
      'chronic': '慢病营养',
      'weight': '减重营养',
      'maternal': '孕产妇营养',
      'functional': '功能性营养',
      'traditional': '中医营养',
      'safety': '食品安全',
    };
    return names[specialization] ?? specialization;
  }

  Color _getLevelColor(String level) {
    switch (level) {
      case 'junior':
        return Colors.green;
      case 'intermediate':
        return Colors.blue;
      case 'senior':
        return Colors.orange;
      case 'expert':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _getLevelName(String level) {
    switch (level) {
      case 'junior':
        return '初级';
      case 'intermediate':
        return '中级';
      case 'senior':
        return '高级';
      case 'expert':
        return '专家';
      default:
        return level;
    }
  }
}