import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('库存管理'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('鸡肉'),
            subtitle: const Text('库存：10 kg'),
            trailing: Icon(Icons.warning, color: Colors.redAccent),
          ),
          // 添加更多库存项
        ],
      ),
    );
  }
}
