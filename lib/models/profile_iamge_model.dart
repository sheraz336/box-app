import 'package:hive_flutter/adapters.dart';
part 'profile_iamge_model.g.dart';

@HiveType(typeId: 4)
class UserModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String email;
  @HiveField(2)
  String phoneNumber;
  @HiveField(3)
  String password;
  @HiveField(4)
  String? profileImage;
  @HiveField(5)
  bool isGuest;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phoneNumber,
    this.profileImage,
    this.isGuest = false,
  });

}
