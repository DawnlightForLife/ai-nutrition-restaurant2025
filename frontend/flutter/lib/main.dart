import 'package:flutter/material.dart';
import 'screens/onboarding/onboarding_page.dart';
import 'screens/user/login_page.dart';
import 'screens/user/health_data_page.dart';
import 'screens/user/recommendation_page.dart';
import 'screens/user/order_page.dart';
import 'screens/user/profile_page.dart';
import 'screens/merchant/dish_management_page.dart';
import 'screens/merchant/inventory_page.dart';
import 'screens/merchant/order_processing_page.dart';
import 'screens/merchant/procurement_page.dart';
import 'screens/merchant/dashboard_page.dart';
import 'screens/nutritionist/enrollment_page.dart';
import 'screens/nutritionist/consultation_page.dart';
import 'screens/nutritionist/optimization_page.dart';
import 'screens/nutritionist/profile_page.dart';
import 'screens/admin/data_management_page.dart';
import 'screens/admin/visualization_page.dart';
import 'screens/admin/user_management_page.dart';

void main() {
  runApp(SmartNutritionRestaurantApp());
}

class SmartNutritionRestaurantApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '智慧AI营养餐厅',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green[800],
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.green)
            .copyWith(secondary: Colors.greenAccent),
        textTheme: TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      // 初始先显示欢迎/启动页，后续跳转到登录页
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/login': (context) => LoginPage(),
        '/health': (context) => HealthDataPage(),
        '/recommendation': (context) => RecommendationPage(),
        '/order': (context) => OrderPage(),
        '/user/profile': (context) => ProfilePage(),
        '/merchant/dish': (context) => DishManagementPage(),
        '/merchant/inventory': (context) => InventoryPage(),
        '/merchant/order': (context) => OrderProcessingPage(),
        '/merchant/procurement': (context) => ProcurementPage(),
        '/merchant/dashboard': (context) => DashboardPage(),
        '/nutritionist/enroll': (context) => EnrollmentPage(),
        '/nutritionist/consultation': (context) => ConsultationPage(),
        '/nutritionist/optimization': (context) => OptimizationPage(),
        '/nutritionist/profile': (context) => NutritionistProfilePage(),
        '/admin/data': (context) => DataManagementPage(),
        '/admin/visualization': (context) => VisualizationPage(),
        '/admin/user': (context) => UserManagementPage(),
      },
      // 主界面采用底部导航，登录后进入 HomePage（这里用用户个人中心作为示例）
      home: HomePage(),
    );
  }
}

// 主界面：底部导航示例，5个Tab入口
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  // 5个页面：首页推荐、AI营养推荐、社区论坛、购物车/订单、个人中心
  final List<Widget> _pages = [
    RecommendationPage(), // 作为首页推荐示例
    HealthDataPage(),     // 作为AI营养推荐入口（后续可独立设计更丰富页面）
    Center(child: Text('社区论坛页面', style: TextStyle(fontSize: 24))), // 占位
    OrderPage(),          // 购物车/订单页面
    ProfilePage(),        // 个人中心
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[800],
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: '营养推荐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: '论坛',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: '订单',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
