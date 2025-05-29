import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/router/app_router.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);
    final theme = ref.watch(appThemeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: '元气营养',
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ref.watch(themeModeProvider),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('en', 'US'),
      ],
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Provider定义
final appRouterProvider = Provider((ref) => AppRouter());

final appThemeProvider = Provider((ref) => AppTheme());

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

final localeProvider = StateProvider<Locale?>((ref) => null);