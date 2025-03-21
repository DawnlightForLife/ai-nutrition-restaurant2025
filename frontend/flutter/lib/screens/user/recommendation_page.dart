import 'package:flutter/material.dart';

class RecommendationPage extends StatefulWidget {
  const RecommendationPage({Key? key}) : super(key: key);
  
  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  double _preferenceValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养推荐'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: ListTile(
                leading: Icon(Icons.restaurant_menu, size: 50, color: Colors.green[800]),
                title: const Text('今日推荐营养餐', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('均衡营养，美味健康'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text('调整口味偏好:', style: TextStyle(fontSize: 16)),
                Expanded(
                  child: Slider(
                    value: _preferenceValue,
                    onChanged: (value) {
                      setState(() {
                        _preferenceValue = value;
                      });
                    },
                    activeColor: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/order');
              },
              child: const Text('确认推荐并下单', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
