import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/merchant_stats_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/chart_card.dart';

/// 加盟商统计管理页面
class MerchantStatsPage extends ConsumerStatefulWidget {
  const MerchantStatsPage({super.key});

  @override
  ConsumerState<MerchantStatsPage> createState() => _MerchantStatsPageState();
}

class _MerchantStatsPageState extends ConsumerState<MerchantStatsPage> {
  String _selectedTimeRange = '本月';
  
  @override
  void initState() {
    super.initState();
    // 初始加载数据
    Future.microtask(() {
      ref.read(merchantStatsProvider.notifier).loadStats();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statsAsync = ref.watch(merchantStatsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('加盟商数据统计'),
        actions: [
          // 时间范围选择
          PopupMenuButton<String>(
            initialValue: _selectedTimeRange,
            onSelected: (value) {
              setState(() {
                _selectedTimeRange = value;
              });
              ref.read(merchantStatsProvider.notifier).loadStats(timeRange: value);
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
              ref.read(merchantStatsProvider.notifier).loadStats();
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
                  ref.read(merchantStatsProvider.notifier).loadStats();
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
        await ref.read(merchantStatsProvider.notifier).loadStats();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 门店概况统计
            Text(
              '门店概况',
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
                  title: '加盟商总数',
                  value: (stats['overview']['totalMerchants'] ?? 0).toString(),
                  icon: Icons.business,
                  color: Colors.blue,
                  trend: '+${stats['overview']['newMerchantsThisMonth'] ?? 0}',
                  trendLabel: '本月新增',
                ),
                StatCard(
                  title: '门店总数',
                  value: (stats['overview']['totalStores'] ?? 0).toString(),
                  icon: Icons.store,
                  color: Colors.orange,
                  trend: '+${stats['overview']['newStoresThisMonth'] ?? 0}',
                  trendLabel: '本月新增',
                ),
                StatCard(
                  title: '正常营业',
                  value: (stats['overview']['activeStores'] ?? 0).toString(),
                  icon: Icons.check_circle,
                  color: Colors.green,
                  percentage: _calculatePercentage(
                    stats['overview']['activeStores'] as int? ?? 0,
                    stats['overview']['totalStores'] as int? ?? 1,
                  ),
                ),
                StatCard(
                  title: '待审核',
                  value: (stats['overview']['pendingStores'] ?? 0).toString(),
                  icon: Icons.pending,
                  color: Colors.amber,
                  percentage: _calculatePercentage(
                    stats['overview']['pendingStores'] as int? ?? 0,
                    stats['overview']['totalStores'] as int? ?? 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // 加盟商类型分布
            ChartCard(
              title: '加盟商类型分布',
              child: _buildTypeDistributionChart(stats['overview']['typeDistribution']),
            ),
            const SizedBox(height: 24),
            
            // 订单与营收数据
            Text(
              '订单与营收',
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
                  title: '总订单数',
                  value: _formatNumber(stats['orderRevenue']['totalOrders']),
                  icon: Icons.receipt_long,
                  color: Colors.teal,
                  subtitle: '日均 ${stats['orderRevenue']['avgOrdersPerDay']}',
                ),
                StatCard(
                  title: '总营收',
                  value: '¥${_formatNumber(stats['orderRevenue']['totalRevenue'])}',
                  icon: Icons.monetization_on,
                  color: Colors.green,
                  subtitle: '日均 ¥${_formatNumber(stats['orderRevenue']['avgRevenuePerDay'])}',
                ),
                StatCard(
                  title: '平均客单价',
                  value: '¥${stats['orderRevenue']['avgOrderValue'].toStringAsFixed(2)}',
                  icon: Icons.shopping_cart,
                  color: Colors.purple,
                ),
                StatCard(
                  title: '订单完成率',
                  value: '${stats['orderRevenue']['completionRate'].toStringAsFixed(1)}%',
                  icon: Icons.task_alt,
                  color: Colors.indigo,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 热销菜品Top10
            ChartCard(
              title: '热销菜品 TOP 10',
              child: _buildTopDishesChart(stats['orderRevenue']['topDishes']),
            ),
            const SizedBox(height: 24),
            
            // 用户行为分析
            Text(
              '用户行为分析',
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
                  title: '活跃用户数',
                  value: _formatNumber(stats['userBehavior']['activeUsers']),
                  icon: Icons.people,
                  color: Colors.blue,
                  subtitle: 'UV',
                ),
                StatCard(
                  title: '新用户占比',
                  value: '${stats['userBehavior']['newUserRate'].toStringAsFixed(1)}%',
                  icon: Icons.person_add,
                  color: Colors.green,
                ),
                StatCard(
                  title: '复购率',
                  value: '${stats['userBehavior']['returnRate'].toStringAsFixed(1)}%',
                  icon: Icons.repeat,
                  color: Colors.orange,
                ),
                StatCard(
                  title: '转化率',
                  value: '${stats['userBehavior']['conversionRate'].toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 商家运营质量指标
            Text(
              '运营质量指标',
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
                  title: '菜品上架率',
                  value: '${stats['operationalQuality']['dishListingRate'].toStringAsFixed(1)}%',
                  icon: Icons.restaurant_menu,
                  color: Colors.green,
                  status: stats['operationalQuality']['dishListingRate'] > 80 
                    ? 'good' : 'warning',
                ),
                StatCard(
                  title: '库存报警',
                  value: stats['operationalQuality']['inventoryAlerts'].toString(),
                  icon: Icons.warning,
                  color: Colors.red,
                  status: stats['operationalQuality']['inventoryAlerts'] > 0 
                    ? 'bad' : 'good',
                ),
                StatCard(
                  title: '投诉数量',
                  value: stats['operationalQuality']['complaintsCount'].toString(),
                  icon: Icons.report_problem,
                  color: Colors.orange,
                  status: stats['operationalQuality']['complaintsCount'] > 5 
                    ? 'bad' : 'good',
                ),
                StatCard(
                  title: '活动参与率',
                  value: '${stats['operationalQuality']['promotionParticipationRate'].toStringAsFixed(1)}%',
                  icon: Icons.local_offer,
                  color: Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // 加盟商排行榜
            _buildMerchantRanking(context, stats['topMerchants']),
          ],
        ),
      ),
    );
  }
  
  /// 构建类型分布图表
  Widget _buildTypeDistributionChart(List<dynamic> data) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.map((item) {
            final value = item['count'].toDouble();
            final total = data.fold<int>(0, (sum, item) => sum + item['count'] as int);
            final percentage = (value / total * 100).toStringAsFixed(1);
            
            return PieChartSectionData(
              value: value,
              title: '${item['type']}\n$percentage%',
              radius: 80,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              color: _getColorForType(item['type']),
            );
          }).toList(),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
        ),
      ),
    );
  }
  
  /// 构建热销菜品图表
  Widget _buildTopDishesChart(List<dynamic> data) {
    final topDishes = data.take(10).toList();
    
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: topDishes.isEmpty ? 100 : topDishes.first['sales'].toDouble() * 1.2,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (group) => Colors.blueGrey.withOpacity(0.8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final dish = topDishes[groupIndex];
                return BarTooltipItem(
                  '${dish['name']}\n销量: ${dish['sales']}',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < topDishes.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        topDishes[index]['name'].toString().length > 5
                          ? '${topDishes[index]['name'].toString().substring(0, 5)}...'
                          : topDishes[index]['name'],
                        style: const TextStyle(fontSize: 10),
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
          barGroups: topDishes.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value['sales'].toDouble(),
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
  
  /// 构建加盟商排行榜
  Widget _buildMerchantRanking(BuildContext context, List<dynamic> merchants) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '加盟商排行榜',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: merchants.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final merchant = merchants[index];
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
                title: Text(merchant['name']),
                subtitle: Text('${merchant['storeCount']} 家门店'),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '¥${_formatNumber(merchant['revenue'])}',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${merchant['orderCount']} 单',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
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
  
  /// 获取类型对应的颜色
  Color _getColorForType(String type) {
    final colors = {
      'restaurant': Colors.orange,
      'fast_food': Colors.red,
      'drink_shop': Colors.blue,
      'bakery': Colors.brown,
      'other': Colors.grey,
    };
    return colors[type] ?? Colors.grey;
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
}