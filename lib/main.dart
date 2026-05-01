import 'package:flutter/material.dart';
import 'package:ride_app/services/routing/router.dart';
import 'package:ride_app/services/storage/hive_db.dart';
import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppNavigator.init();
  await HiveDB.instance.init();

  runApp(const MyApp());
}
