import 'package:flutter/material.dart';
import 'services/routing/router.dart';
import 'theme/theme.dart';


/// Application entry point.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.petroleumModernismLightTheme,
      routerConfig: AppNavigator.router,
    );
  }
}
