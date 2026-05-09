import 'package:hive_flutter/hive_flutter.dart';
import 'package:ride_app/features/auth/models/user_model.dart';


abstract class HiveKeys {
  static const appBox = 'appBox';
  static const userBox = 'userBox';
  static const userData = 'userData';
}

class HiveDB {
  HiveDB._();

  static final HiveDB instance = HiveDB._();

  late Box _userBox;

  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserHiveModelAdapter());
    _userBox = await Hive.openBox(HiveKeys.userBox);
  }

  Future<void> saveUser(UserHiveModel user) async {
    await _userBox.put(HiveKeys.userData, user);
  }

  UserHiveModel? getUserData() {
    return _userBox.get(HiveKeys.userData);
  }

  Future<void> deleteUserData() async {
    await _userBox.delete(HiveKeys.userData);
  }
}
