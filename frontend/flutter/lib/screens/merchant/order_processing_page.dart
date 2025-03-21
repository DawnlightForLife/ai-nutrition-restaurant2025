import 'package:flutter/material.dart';

class OrderProcessingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('订单处理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildOrderTile('订单 #12345', '待处理'),
          _buildOrderTile('订单 #12346', '待处理'),
        ],
      ),
    );
  }

  Widget _buildOrderTile(String orderId, String status) {
    return ListTile(
      title: Text(orderId, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(status),
      trailing: ElevatedButton(
        onPressed: () {
          // 处理订单逻辑
        },
        child: Text('处理'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
