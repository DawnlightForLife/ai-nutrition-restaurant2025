import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'routes/app_router.dart';
import 'l10n/app_localizations.dart';

/// App Theme Provider
final appThemeProvider = Provider<AppTheme>((ref) {
  return AppTheme();
});

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812), // 设计尺寸
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: '营养立方',
          theme: appTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [AppRouter.observer],
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, ref),
        );
      },
    );
  }
}