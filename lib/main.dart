import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:numi/core/settings/app_settings.dart';
import 'package:numi/core/theme/dark_theme.dart';
import 'package:numi/core/theme/light_theme.dart';
import 'bloc_provider.dart';
import 'bottom_nav_bar.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setup();
  runApp(MyBlocProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      settings: AppSettings.instance,
      child: Builder(
        builder: (ctx) {
          final settings = AppSettings.of(ctx);
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                title: 'Numi',
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: settings.themeMode,
                home: const NumiBottomNav(),
              );
            },
          );
        },
      ),
    );
  }
}
