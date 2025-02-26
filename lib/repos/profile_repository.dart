import 'package:box_delivery_app/models/profile_iamge_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

class ProfileRepository extends ChangeNotifier{
  static final boxName = "profile";
  static final instance = ProfileRepository();
  static const myProfileKey = "currentProfile";
  late final Box _box;
  UserModel? _profile;

  UserModel? get profile=>_profile;

  Future<void> init() async {
    _box = await Hive.openBox<UserModel>(boxName);
    _profile = await _box.get(myProfileKey);
  }

  Future<void> update(UserModel profile)async {
    _profile = profile;
    await _box.put(myProfileKey, profile);
    notifyListeners();
  }
  Future<void> logout()async {
    await _box.delete(myProfileKey);
    _profile=null;
  }

  bool isGuest(){
    return _profile?.isGuest ?? true;
  }

  bool isLoggedIn(){
    return _profile != null;
  }
}
