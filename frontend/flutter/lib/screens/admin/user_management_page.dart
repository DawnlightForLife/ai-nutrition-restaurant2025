import 'package:flutter/material.dart';

class UserManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('后台用户管理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('用户A'),
            subtitle: Text('注册信息及状态'),
            trailing: Icon(Icons.edit, color: Colors.green[800]),
            onTap: () {
              // 跳转到用户详情页面
            },
          ),
          // 更多用户记录
        ],
      ),
    );
  }
}
