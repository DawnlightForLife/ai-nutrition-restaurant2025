import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/base_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/base/chart_config.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/nutrition/nutrition_pie_chart.dart';
import 'package:ai_nutrition_restaurant/presentation/components/charts/nutrition/nutrition_trend_chart.dart';

void main() {
  group('Chart Golden Tests', () {
    setUpAll(() async {
      await loadAppFonts();
    });
    
    testGoldens('Nutrition Pie Chart - Light Theme', (tester) async {
      final mockData = [
        NutritionData(name: 'Protein', value: 25.5, color: Colors.blue),
        NutritionData(name: 'Carbs', value: 45.2, color: Colors.orange),
        NutritionData(name: 'Fat', value: 15.8, color: Colors.green),
        NutritionData(name: 'Fiber', value: 8.3, color: Colors.purple),
      ];
      
      final widget = MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: NutritionPieChart(
                data: mockData,
                config: const ChartConfig(
                  height: 300,
                ),
                title: 'Nutrition Distribution',
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'nutrition_pie_chart_light');
    });
    
    testGoldens('Nutrition Pie Chart - Dark Theme', (tester) async {
      final mockData = [
        NutritionData(name: 'Protein', value: 25.5),
        NutritionData(name: 'Carbs', value: 45.2),
        NutritionData(name: 'Fat', value: 15.8),
        NutritionData(name: 'Fiber', value: 8.3),
      ];
      
      final widget = MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: NutritionPieChart(
                data: mockData,
                config: const ChartConfig(
                  theme: ChartTheme.dark,
                  height: 300,
                ),
                title: 'Nutrition Distribution',
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'nutrition_pie_chart_dark');
    });
    
    testGoldens('Nutrition Trend Chart', (tester) async {
      final now = DateTime.now();
      final mockTrends = [
        NutrientTrendData(
          name: 'Calories',
          goalValue: 2000,
          color: Colors.blue,
          points: List.generate(7, (i) {
            return NutritionTrendPoint(
              date: now.subtract(Duration(days: 6 - i)),
              value: 1800 + (i * 50),
            );
          }),
        ),
        NutrientTrendData(
          name: 'Protein',
          goalValue: 60,
          color: Colors.green,
          points: List.generate(7, (i) {
            return NutritionTrendPoint(
              date: now.subtract(Duration(days: 6 - i)),
              value: 50 + (i * 2),
            );
          }),
        ),
      ];
      
      final widget = MaterialApp(
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 600,
              height: 400,
              child: NutritionTrendChart(
                nutrients: mockTrends,
                config: const ChartConfig(
                  height: 350,
                ),
                title: 'Weekly Nutrition Trends',
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpWidgetBuilder(widget);
      await screenMatchesGolden(tester, 'nutrition_trend_chart');
    });
    
    group('Chart States', () {
      testGoldens('Chart Loading State', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 300,
                child: BaseChart.loading(
                  config: const ChartConfig(),
                ),
              ),
            ),
          ),
        );
        
        await tester.pumpWidgetBuilder(widget);
        await screenMatchesGolden(tester, 'chart_loading_state');
      });
      
      testGoldens('Chart Error State', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 300,
                child: BaseChart.error(
                  message: 'Failed to load chart data',
                  config: const ChartConfig(),
                  onRetry: () {},
                ),
              ),
            ),
          ),
        );
        
        await tester.pumpWidgetBuilder(widget);
        await screenMatchesGolden(tester, 'chart_error_state');
      });
      
      testGoldens('Chart Empty State', (tester) async {
        final widget = MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                height: 300,
                child: BaseChart.empty(
                  message: 'No data available',
                  config: const ChartConfig(),
                  action: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Add Data'),
                  ),
                ),
              ),
            ),
          ),
        );
        
        await tester.pumpWidgetBuilder(widget);
        await screenMatchesGolden(tester, 'chart_empty_state');
      });
    });
  });
}