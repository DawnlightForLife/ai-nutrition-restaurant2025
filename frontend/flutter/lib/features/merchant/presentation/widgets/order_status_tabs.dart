import 'package:flutter/material.dart';
import '../../domain/entities/order_entity.dart';

class OrderStatusTabs extends StatelessWidget {
  final TabController tabController;
  final List<OrderStatus?> statusList;
  final Map<OrderStatus?, int> orderCounts;

  const OrderStatusTabs({
    Key? key,
    required this.tabController,
    required this.statusList,
    required this.orderCounts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: statusList.map((status) {
        final count = orderCounts[status] ?? 0;
        final label = status?.displayName ?? '全部';
        
        return Tab(
          child: Row(
            children: [
              Text(label),
              if (count > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: status?.color ?? Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}