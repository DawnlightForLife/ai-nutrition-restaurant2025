import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme/yuanqi_colors.dart';
import '../config/app_config.dart';

// Import components
import 'components/buttons_component.dart';
import 'components/inputs_component.dart';
import 'components/cards_component.dart';
import 'screens/login_screen_component.dart';

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Widgetbook(
      directories: [
        WidgetbookFolder(
          name: '基础组件',
          children: [
            buttonsComponent,
            inputsComponent,
            cardsComponent,
          ],
        ),
        WidgetbookFolder(
          name: '页面',
          children: [
            loginScreenComponent,
          ],
        ),
      ],
      addons: [
        DeviceFrameAddon(
          devices: [
            Devices.ios.iPhone13,
            Devices.ios.iPhone13ProMax,
            Devices.ios.iPad,
            Devices.android.samsungGalaxyS20,
            Devices.android.mediumTablet,
          ],
        ),
        ThemeAddon<AppThemeData>(
          themes: [
            WidgetbookTheme(
              name: '默认主题',
              data: AppThemeData.light,
            ),
            WidgetbookTheme(
              name: '暗色主题',
              data: AppThemeData.dark,
            ),
          ],
          themeBuilder: (context, theme, child) {
            return MaterialApp(
              theme: theme.toThemeData(),
              home: child,
            );
          },
        ),
        TextScaleAddon(
          scales: [1.0, 1.5, 2.0],
        ),
        LocalizationAddon(
          locales: [
            const Locale('zh', 'CN'),
            const Locale('en', 'US'),
          ],
          localizationsDelegates: [
            DefaultWidgetsLocalizations.delegate,
            DefaultMaterialLocalizations.delegate,
          ],
        ),
        InspectorAddon(enabled: true),
        GridAddon(),
      ],
    );
  }
}

// 主题数据
class AppThemeData {
  final ThemeData themeData;
  
  const AppThemeData(this.themeData);
  
  static final light = AppThemeData(
    ThemeData(
      primaryColor: YuanqiColors.primaryOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: YuanqiColors.primaryOrange,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: YuanqiColors.textPrimary),
        titleTextStyle: TextStyle(
          color: YuanqiColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
  
  static final dark = AppThemeData(
    ThemeData(
      primaryColor: YuanqiColors.primaryOrange,
      colorScheme: ColorScheme.fromSeed(
        seedColor: YuanqiColors.primaryOrange,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
  
  ThemeData toThemeData() => themeData;
}

