import 'package:hive/hive.dart';

part 'user_model.g.dart';


abstract interface class AbstractUserModel {
  String get name;
  String get phoneNo;
}


@HiveType(typeId: 0)
class UserHiveModel extends AbstractUserModel with HiveObjectMixin {

  @HiveField(0)
  @override
  String name;

  @HiveField(1)
  @override
  String phoneNo;

  UserHiveModel({
    required this.name,
    required this.phoneNo,
  });

  @override
  String toString() {
    return 'UserHiveModel(name=$name, phoneNo=$phoneNo)';
  }
}
