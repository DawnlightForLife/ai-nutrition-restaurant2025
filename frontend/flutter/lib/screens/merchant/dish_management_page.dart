import 'package:flutter/material.dart';

class DishManagementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('菜品管理'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildDishCard('宫保鸡丁', '¥38', Icons.fastfood),
          _buildDishCard('鱼香肉丝', '¥42', Icons.restaurant),
        ],
      ),
    );
  }

  Widget _buildDishCard(String name, String price, IconData icon) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 40, color: Colors.green[800]),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('价格：$price'),
        trailing: Icon(Icons.edit, color: Colors.grey[600]),
        onTap: () {
          // 编辑菜品逻辑
        },
      ),
    );
  }
}
