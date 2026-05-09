import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ride_app/services/routing/router.dart';
import 'package:ride_app/services/storage/hive_db.dart';
import 'app.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AppNavigator.init();
  await HiveDB.instance.init();

  runApp(const MyApp());
}
