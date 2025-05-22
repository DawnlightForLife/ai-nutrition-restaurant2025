import 'package:flutter/material.dart';
import 'package:ai_nutrition_restaurant/gen/assets.gen.dart';
import 'package:ai_nutrition_restaurant/app/router.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': '智能推荐',
      'desc': '基于健康数据提供个性化营养建议',
      'image': Assets.images.intro1.path,
    },
    {
      'title': '营养社群',
      'desc': '加入社区，交流健康心得，获取营养师支持',
      'image': Assets.images.intro2.path,
    },
    {
      'title': '一人多档',
      'desc': '为自己、子女、父母建立多份档案',
      'image': Assets.images.intro3.path,
    },
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.splash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _pages.length,
              itemBuilder: (_, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(page['image']!, height: 240),
                      const SizedBox(height: 32),
                      Text(page['title']!, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      Text(page['desc']!, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey.shade300,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: _nextPage,
              child: Text(_currentPage == _pages.length - 1 ? '开始体验' : '下一步'),
            ),
          ),
        ],
      ),
    );
  }
}