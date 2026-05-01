import 'package:flutter/material.dart';
import 'package:ride_app/services/routing/router.dart';
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
