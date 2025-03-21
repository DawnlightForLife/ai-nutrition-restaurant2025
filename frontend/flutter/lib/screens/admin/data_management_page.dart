import 'package:flutter/material.dart';

class DataManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户数据管理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('用户1'),
            subtitle: Text('健康数据详情……'),
          ),
          // 更多数据项
        ],
      ),
    );
  }
}
