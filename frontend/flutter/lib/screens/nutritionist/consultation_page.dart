import 'package:flutter/material.dart';

class ConsultationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('用户咨询管理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text('用户咨询1'),
            subtitle: Text('内容预览……'),
            trailing: Icon(Icons.arrow_forward, color: Colors.green[800]),
            onTap: () {
              // 跳转到详细咨询页面
            },
          ),
          // 更多咨询记录
        ],
      ),
    );
  }
}
