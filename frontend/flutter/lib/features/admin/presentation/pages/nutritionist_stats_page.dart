import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/nutritionist_stats_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_card.dart';

/// 营养师统计管理页面
class NutritionistStatsPage extends ConsumerStatefulWidget {
  const NutritionistStatsPage({super.key});

  @override
  ConsumerState<NutritionistStatsPage> createState() => _NutritionistStatsPageState();
}

class _NutritionistStatsPageState extends ConsumerState<NutritionistStatsPage> {
  String _selectedTimeRange = '本月';
  String _rankingType = 'consultation';
  
  @override
  void initState() {
    super.initState();
    // 初始加载数据
    Future.microtask(() {
      ref.read(nutritionistStatsProvider.notifier).loadStats();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(nutritionistStatsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养师数据统计'),
        actions: [
          // 时间范围选择
          PopupMenuButton<String>(
            initialValue: _selectedTimeRange,
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
              ref.read(nutritionistStatsProvider.notifier).loadStats(timeRange: value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '今日', child: Text('今日')),
              const PopupMenuItem(value: '本周', child: Text('本周')),
              const PopupMenuItem(value: '本月', child: Text('本月')),
              const PopupMenuItem(value: '本年', child: Text('本年')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Text(_selectedTimeRange),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(nutritionistStatsProvider.notifier).loadStats();
            },
          ),
        ],
      ),
      body: statsAsync.when(
        data: (stats) => _buildContent(context, stats),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(nutritionistStatsProvider.notifier).loadStats();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildContent(BuildContext context, Map<String, dynamic> stats) {
    final theme = Theme.of(context);
    
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(nutritionistStatsProvider.notifier).loadStats();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 营养师基本信息统计
            Text(
              '营养师概况',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: '营养师总数',
                  value: stats['overview']['totalNutritionists'].toString(),
                  icon: Icons.person,
                  color: Colors.blue,
                  trend: '+${stats['overview']['newNutritionistsThisMonth']}',
                  trendLabel: '本月新增',
                ),
                StatCard(
                  title: '认证通过',
                  value: stats['overview']['certifiedNutritionists'].toString(),
                  icon: Icons.verified,
                  color: Colors.green,
                  percentage: _calculatePercentage(
                    stats['overview']['certifiedNutritionists'],
                    stats['overview']['totalNutritionists'],
                  ),
                ),
                StatCard(
                  title: '活跃营养师',
                  value: stats['overview']['activeNutritionists'].toString(),
                  icon: Icons.trending_up,
                  color: Colors.orange,
                  subtitle: '近30天有咨询',
                ),
                StatCard(
                  title: '等级分布',
                  value: '${stats['overview']['levelDistribution'].length}',
                  icon: Icons.star,
                  color: Colors.purple,
                  subtitle: '个等级',
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 营养师等级分布图
            if (stats['overview']['levelDistribution'].isNotEmpty)
              ChartCard(
                title: '营养师等级分布',
                child: _buildLevelDistributionChart(stats['overview']['levelDistribution']),
              ),
            const SizedBox(height: 32),
            
            // 咨询服务数据
            Text(
              '咨询服务数据',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: '总咨询数',
                  value: _formatNumber(stats['consultation']['totalConsultations']),
                  icon: Icons.chat,
                  color: Colors.teal,
                ),
                StatCard(
                  title: '平均响应时间',
                  value: _formatDuration(stats['consultation']['responseTimeStats']['avgResponseTime']),
                  icon: Icons.access_time,
                  color: Colors.blue,
                ),
                StatCard(
                  title: '好评率',
                  value: '${stats['consultation']['goodRatingRate']}%',
                  icon: Icons.thumb_up,
                  color: Colors.green,
                  status: stats['consultation']['goodRatingRate'] > 90 ? 'good' : 'warning',
                ),
                StatCard(
                  title: '评价总数',
                  value: _formatNumber(stats['consultation']['ratingDistribution'].fold<int>(
                    0, (int sum, dynamic item) => sum + (item['count'] as int)
                  )),
                  icon: Icons.star_rate,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 每日咨询趋势
            ChartCard(
              title: '每日咨询趋势',
              child: _buildDailyConsultationChart(stats['consultation']['dailyConsultations']),
            ),
            const SizedBox(height: 24),
            
            // 用户评分分布
            ChartCard(
              title: '用户评分分布',
              child: _buildRatingDistributionChart(stats['consultation']['ratingDistribution']),
            ),
            const SizedBox(height: 32),
            
            // 营养推荐行为分析
            Text(
              '营养推荐分析',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: '总推荐次数',
                  value: _formatNumber(stats['recommendation']['totalRecommendations']),
                  icon: Icons.recommend,
                  color: Colors.indigo,
                ),
                StatCard(
                  title: '推荐成功率',
                  value: '${stats['recommendation']['successRate']}%',
                  icon: Icons.check_circle,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'AI推荐',
                  value: _formatNumber(stats['recommendation']['recommendationSource']['ai']),
                  icon: Icons.psychology,
                  color: Colors.purple,
                  subtitle: '次',
                ),
                StatCard(
                  title: '人工推荐',
                  value: _formatNumber(stats['recommendation']['recommendationSource']['manual']),
                  icon: Icons.person,
                  color: Colors.blue,
                  subtitle: '次',
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 推荐内容类型分布
            if (stats['recommendation']['recommendationTypes'].isNotEmpty)
              ChartCard(
                title: '推荐内容类型分布',
                child: _buildRecommendationTypeChart(stats['recommendation']['recommendationTypes']),
              ),
            const SizedBox(height: 32),
            
            // 收入与分成统计
            Text(
              '收入统计',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: '咨询总收入',
                  value: '¥${_formatNumber(stats['income']['consultationIncome']['totalIncome'])}',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                ),
                StatCard(
                  title: '平均收入',
                  value: '¥${stats['income']['consultationIncome']['avgIncome'].toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  color: Colors.blue,
                  subtitle: '每单',
                ),
                StatCard(
                  title: '待结算金额',
                  value: '¥${_formatNumber(_calculateTotalSettlement(stats['income']['monthlySettlement']))}',
                  icon: Icons.account_balance_wallet,
                  color: Colors.orange,
                  subtitle: '本月',
                ),
                StatCard(
                  title: '提现总额',
                  value: '¥${_formatNumber(stats['income']['withdrawalStats']['totalWithdrawnAmount'])}',
                  icon: Icons.payment,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // 营养师排行榜
            _buildNutritionistRanking(context, stats['ranking']),
          ],
        ),
      ),
    );
  }
  
  /// 构建等级分布图表
  Widget _buildLevelDistributionChart(List<dynamic> data) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.isEmpty ? 10 : data.map((e) => e['count'].toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.8),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Lv.${data[index]['level']}',
                        style: const TextStyle(fontSize: 12),
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
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value['count'].toDouble(),
                  color: Colors.blue,
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
    );
  }
  
  /// 构建每日咨询趋势图
  Widget _buildDailyConsultationChart(List<dynamic> data) {
    if (data.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }
    
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < data.length) {
                    final date = data[index]['date'].toString();
                    final parts = date.split('-');
                    if (parts.length >= 3) {
                      return Text(
                        '${parts[1]}-${parts[2]}',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value['count'].toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 构建评分分布图表
  Widget _buildRatingDistributionChart(List<dynamic> data) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: data.isEmpty ? 10 : data.map((e) => e['count'].toDouble()).reduce((a, b) => a > b ? a : b) * 1.2,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final rating = 5 - value.toInt();
                  return Row(
                    children: List.generate(
                      rating,
                      (index) => const Icon(
                        Icons.star,
                        size: 10,
                        color: Colors.amber,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(5, (index) {
            final rating = 5 - index;
            final item = data.firstWhere(
              (e) => e['rating'] == rating,
              orElse: () => {'rating': rating, 'count': 0},
            );
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item['count'].toDouble(),
                  color: rating >= 4 ? Colors.green : (rating == 3 ? Colors.orange : Colors.red),
                  width: 30,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
  
  /// 构建推荐类型分布图
  Widget _buildRecommendationTypeChart(List<dynamic> data) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
    ];
    
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.asMap().entries.map((entry) {
            final value = entry.value['count'].toDouble();
            final total = data.fold<int>(0, (int sum, dynamic item) => sum + item['count'] as int);
            final percentage = (value / total * 100).toStringAsFixed(1);
            
            return PieChartSectionData(
              value: value,
              title: '${_getRecommendationTypeName(entry.value['type'])}\n$percentage%',
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              color: colors[entry.key % colors.length],
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
  
  /// 构建营养师排行榜
  Widget _buildNutritionistRanking(BuildContext context, Map<String, dynamic> ranking) {
    final theme = Theme.of(context);
    final rankingData = ranking[_rankingType] ?? [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '营养师排行榜',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // 排行榜类型选择
            Flexible(
              flex: 3,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                    value: 'consultation',
                    label: Text('咨询量'),
                    icon: Icon(Icons.chat),
                  ),
                  ButtonSegment(
                    value: 'rating',
                    label: Text('评分'),
                    icon: Icon(Icons.star),
                  ),
                  ButtonSegment(
                    value: 'income',
                    label: Text('收入'),
                    icon: Icon(Icons.attach_money),
                  ),
                ],
                selected: {_rankingType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _rankingType = newSelection.first;
                  });
                  ref.read(nutritionistStatsProvider.notifier).loadRanking(_rankingType);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rankingData.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final nutritionist = rankingData[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRankColor(index),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(nutritionist['nutritionistName'] ?? '未知'),
                subtitle: _buildRankingSubtitle(nutritionist),
                trailing: _buildRankingTrailing(context, nutritionist),
              );
            },
          ),
        ),
      ],
    );
  }
  
  /// 构建排行榜副标题
  Widget _buildRankingSubtitle(Map<String, dynamic> nutritionist) {
    switch (_rankingType) {
      case 'consultation':
        return Text('${nutritionist['consultationCount']} 次咨询');
      case 'rating':
        return Row(
          children: [
            Icon(Icons.star, size: 16, color: Colors.amber),
            Expanded(
              child: Text(' ${nutritionist['avgRating']} (${nutritionist['ratingCount']}人评价)'),
            ),
          ],
        );
      case 'income':
        return Text('${nutritionist['consultationCount']} 次咨询');
      default:
        return const SizedBox.shrink();
    }
  }
  
  /// 构建排行榜尾部
  Widget _buildRankingTrailing(BuildContext context, Map<String, dynamic> nutritionist) {
    final theme = Theme.of(context);
    switch (_rankingType) {
      case 'consultation':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${_formatNumber(nutritionist['totalIncome'])}',
              style: theme.textTheme.titleSmall,
            ),
            if (nutritionist['avgRating'] != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  Text(
                    ' ${nutritionist['avgRating']}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
          ],
        );
      case 'rating':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getRatingColor(nutritionist['avgRating']),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${nutritionist['avgRating']}分',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case 'income':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '¥${_formatNumber(nutritionist['totalIncome'])}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Text(
              '均价¥${nutritionist['avgIncomePerConsultation'].toStringAsFixed(2)}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
  
  /// 计算百分比
  String _calculatePercentage(int value, int total) {
    if (total == 0) return '0%';
    return '${(value / total * 100).toStringAsFixed(1)}%';
  }
  
  /// 格式化数字
  String _formatNumber(num value) {
    if (value >= 10000) {
      return '${(value / 10000).toStringAsFixed(1)}万';
    }
    return value.toString();
  }
  
  /// 格式化时长
  String _formatDuration(int milliseconds) {
    if (milliseconds == 0) return '0分钟';
    final minutes = milliseconds ~/ 60000;
    if (minutes < 60) {
      return '$minutes分钟';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '$hours小时$remainingMinutes分钟';
  }
  
  /// 获取推荐类型名称
  String _getRecommendationTypeName(String type) {
    final typeNames = {
      'weight_loss': '减脂',
      'muscle_gain': '增肌',
      'health_management': '健康管理',
      'disease_diet': '病理饮食',
      'pregnancy': '孕期营养',
      'child': '儿童营养',
      'elderly': '老年营养',
      'other': '其他',
    };
    return typeNames[type] ?? type;
  }
  
  /// 获取排名对应的颜色
  Color _getRankColor(int rank) {
    switch (rank) {
      case 0:
        return Colors.amber;
      case 1:
        return Colors.grey;
      case 2:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }
  
  /// 获取评分对应的颜色
  Color _getRatingColor(double rating) {
    if (rating >= 4.5) return Colors.green;
    if (rating >= 4.0) return Colors.blue;
    if (rating >= 3.5) return Colors.orange;
    return Colors.red;
  }
  
  /// 计算总结算金额
  double _calculateTotalSettlement(List<dynamic> settlements) {
    return settlements.fold<double>(
      0, 
      (sum, item) => sum + (item['settlementAmount'] ?? 0).toDouble()
    );
  }
}