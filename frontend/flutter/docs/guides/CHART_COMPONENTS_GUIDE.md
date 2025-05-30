# Chart Components Guide

## Overview
This guide documents the unified chart component system for data visualization in the Smart Nutrition Restaurant application.

## Architecture

### Directory Structure
```
lib/presentation/components/charts/
├── base/                    # Base classes and configurations
│   ├── base_chart.dart     # Abstract base class for all charts
│   └── chart_config.dart   # Configuration and theming
├── nutrition/              # Nutrition-specific charts
│   ├── nutrition_pie_chart.dart
│   └── nutrition_trend_chart.dart
├── analytics/              # Analytics charts
├── restaurant/             # Restaurant-specific charts
├── themes/                 # Chart theme presets
└── chart_registry.dart     # Widgetbook integration and catalog
```

## Base Components

### ChartConfig
Unified configuration for all charts:
```dart
final config = ChartConfig(
  theme: ChartTheme.fromTheme(Theme.of(context)),
  showLegend: true,
  showGrid: true,
  showTooltip: true,
  animate: true,
  animationDuration: Duration(milliseconds: 600),
  height: 300,
);
```

### ChartTheme
Consistent theming across all charts:
```dart
// Use current app theme
final theme = ChartTheme.fromTheme(Theme.of(context));

// Or use predefined themes
final darkTheme = ChartTheme.dark;

// Custom theme
final customTheme = ChartTheme(
  primaryColor: Colors.blue,
  palette: [Colors.blue, Colors.green, Colors.orange],
  labelStyle: TextStyle(fontSize: 12),
);
```

## Chart Components

### 1. Nutrition Pie Chart
Display macronutrient distribution:
```dart
NutritionPieChart(
  data: [
    NutritionData(name: 'Protein', value: 25.5),
    NutritionData(name: 'Carbs', value: 45.2),
    NutritionData(name: 'Fat', value: 15.8),
  ],
  config: chartConfig,
  title: 'Daily Macros',
)
```

### 2. Nutrition Trend Chart
Show nutrient trends over time:
```dart
NutritionTrendChart(
  nutrients: [
    NutrientTrendData(
      name: 'Calories',
      goalValue: 2000,
      points: calorieHistory,
    ),
  ],
  config: chartConfig,
  showGoalLines: true,
)
```

## State Handling

### Loading State
```dart
BaseChart.loading(config: chartConfig)
```

### Error State
```dart
BaseChart.error(
  message: 'Failed to load data',
  config: chartConfig,
  onRetry: () => ref.refresh(dataProvider),
)
```

### Empty State
```dart
BaseChart.empty(
  message: 'No data available',
  config: chartConfig,
  action: ElevatedButton(
    onPressed: () => navigateToDataEntry(),
    child: Text('Add Data'),
  ),
)
```

## Widgetbook Integration

All chart components are integrated with Widgetbook for visual testing and documentation.

### Viewing Charts in Widgetbook
1. Run Widgetbook: `flutter run -t lib/widgetbook.dart`
2. Navigate to Components > Charts
3. Select a chart to view different use cases

### Adding New Charts to Widgetbook
```dart
@widgetbook.UseCase(name: 'Default', type: MyNewChart)
Widget myNewChartUseCase(BuildContext context) {
  return MyNewChart(
    data: mockData,
    config: ChartConfig(
      theme: ChartTheme.fromTheme(Theme.of(context)),
    ),
  );
}
```

## Best Practices

### 1. Consistent Configuration
Always use ChartConfig for configuration:
```dart
// Good
final chart = MyChart(
  config: ChartConfig(height: 300),
  data: data,
);

// Avoid
final chart = MyChart(
  height: 300,  // Don't pass individual properties
  data: data,
);
```

### 2. Responsive Design
Use flexible sizing when possible:
```dart
ChartConfig(
  height: MediaQuery.of(context).size.height * 0.3,
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.05,
  ),
)
```

### 3. Theme Integration
Always support both light and dark themes:
```dart
final config = ChartConfig(
  theme: Theme.of(context).brightness == Brightness.dark
      ? ChartTheme.dark
      : ChartTheme.fromTheme(Theme.of(context)),
);
```

### 4. Accessibility
- Provide meaningful labels
- Use sufficient color contrast
- Include alternative text representations

### 5. Performance
- Limit data points for smooth animations
- Use lazy loading for large datasets
- Cache calculated values

## Creating Custom Charts

### Step 1: Extend BaseChart
```dart
class MyCustomChart extends BaseChart {
  final List<MyData> data;
  
  const MyCustomChart({
    Key? key,
    required this.data,
    required ChartConfig config,
    String? title,
  }) : super(key: key, config: config, title: title);
  
  @override
  Widget buildChart(BuildContext context) {
    // Implement your chart here
    return Container();
  }
}
```

### Step 2: Add to Chart Registry
```dart
ChartInfo(
  name: 'My Custom Chart',
  description: 'Description of what it shows',
  widgetBuilder: myCustomChartUseCase,
  category: ChartCategory.custom,
  tags: ['custom', 'special'],
)
```

### Step 3: Create Widgetbook Use Cases
```dart
@widgetbook.UseCase(name: 'Default', type: MyCustomChart)
Widget myCustomChartUseCase(BuildContext context) {
  return MyCustomChart(
    data: generateMockData(),
    config: ChartConfig(),
  );
}
```

## Testing

### Unit Tests
```dart
testWidgets('NutritionPieChart displays data correctly', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: NutritionPieChart(
        data: testData,
        config: ChartConfig(),
      ),
    ),
  );
  
  // Test chart rendering
  expect(find.byType(PieChart), findsOneWidget);
});
```

### Golden Tests
```dart
testGoldens('NutritionPieChart matches golden', (tester) async {
  await tester.pumpWidget(chartWidget);
  await expectLater(
    find.byType(NutritionPieChart),
    matchesGoldenFile('goldens/nutrition_pie_chart.png'),
  );
});
```

## Chart Catalog

Access all available charts:
```dart
// Get all nutrition charts
final nutritionCharts = ChartCatalog.charts['Nutrition'];

// Get charts by category
final trendCharts = ChartCatalog.getChartsByCategory(
  ChartCategory.trend,
);
```

## Troubleshooting

### Chart Not Rendering
- Check data is not empty
- Verify ChartConfig is properly set
- Ensure parent widget has bounded constraints

### Animation Issues
- Check animate flag in ChartConfig
- Verify animationDuration is reasonable
- Test on different devices

### Theme Not Applied
- Ensure ChartTheme.fromTheme() is used
- Check theme is properly propagated
- Verify color values are visible

---

**Last Updated**: $(date)
**Version**: 1.0.0