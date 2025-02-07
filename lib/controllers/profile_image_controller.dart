import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/profile_iamge_model.dart';


class ProfileController with ChangeNotifier {
  UserModel _user = UserModel(
    name: 'John Doe',
    email: 'xxx@gmail.com',
    phoneNumber: '+1234567890',
    password: '********',
  );

  UserModel get user => _user;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        _user = _user.copyWith(profileImage: image.path);
        notifyListeners();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void deleteProfileImage() {
    _user = _user.copyWith(profileImage: null);
    notifyListeners();
  }

  Future<void> logOut() async {
    notifyListeners();
  }

  Future<void> deleteAccount() async {
    notifyListeners();
  }
}