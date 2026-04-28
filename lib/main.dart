import 'package:flutter/material.dart';
import 'package:ride_app/services/routing/router.dart';
import 'app.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppNavigator.init();

  runApp(const MyApp());
}
