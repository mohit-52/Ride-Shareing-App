import 'package:flutter/material.dart';
import 'package:ride_app/services/routing/router.dart';


/// Application entry point
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppNavigator.router,
    );
  }
}
