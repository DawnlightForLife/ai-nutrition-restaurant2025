import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商家仪表板'),
      ),
      body: Center(
        child: Text('这是商家端的仪表板页面'),
      ),
    );
  }
}
