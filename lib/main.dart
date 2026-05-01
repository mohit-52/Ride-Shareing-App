import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/routing/router.dart';
import 'services/storage/hive_db.dart';
import 'firebase_options.dart';
import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AppNavigator.init();
  await HiveDB.instance.init();

  runApp(const MyApp());
}
