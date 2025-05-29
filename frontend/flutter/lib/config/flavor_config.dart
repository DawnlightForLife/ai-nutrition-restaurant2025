enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  static late Flavor _flavor;
  static late String _apiBaseUrl;
  static late String _appTitle;
  
  static Flavor get flavor => _flavor;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get appTitle => _appTitle;
  
  static bool get isDevelopment => _flavor == Flavor.development;
  static bool get isStaging => _flavor == Flavor.staging;
  static bool get isProduction => _flavor == Flavor.production;
  
  FlavorConfig({
    required Flavor flavor,
    required String apiBaseUrl,
    required String appTitle,
  }) {
    _flavor = flavor;
    _apiBaseUrl = apiBaseUrl;
    _appTitle = appTitle;
  }
}