import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户个人中心'),
      ),
      body: Center(
        child: const Text('这是用户个人中心页面', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
