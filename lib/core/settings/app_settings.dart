import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppSettings extends ChangeNotifier {
  // Singleton
  static final AppSettings instance = AppSettings._();
  AppSettings._() {
    final box = Hive.box('settings');
    final saved = box.get('themeMode', defaultValue: 'light') as String;
    _themeMode = saved == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _lang = box.get('lang', defaultValue: 'uz') as String;
  }

  ThemeMode _themeMode = ThemeMode.light;
  String _lang = 'uz';

  static AppSettings of(BuildContext context) => AppSettingsScope.of(context);

  ThemeMode get themeMode => _themeMode;
  String get lang => _lang;

  bool get isDark => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    Hive.box('settings')
        .put('themeMode', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  void cycleLang() {
    const langs = ['uz', 'ru', 'en'];
    final idx = langs.indexOf(_lang);
    _lang = langs[(idx + 1) % langs.length];
    Hive.box('settings').put('lang', _lang);
    notifyListeners();
  }
}

/// InheritedNotifier — barcha avlod widgetlarga AppSettings tarqatadi
class AppSettingsScope extends InheritedNotifier<AppSettings> {
  const AppSettingsScope({
    super.key,
    required AppSettings settings,
    required super.child,
  }) : super(notifier: settings);

  static AppSettings of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppSettingsScope>()!
        .notifier!;
  }
}
