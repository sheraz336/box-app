import 'package:box_delivery_app/repos/box_repository.dart';
import 'package:box_delivery_app/repos/item_repository.dart';
import 'package:box_delivery_app/repos/location_repository.dart';
import 'package:box_delivery_app/repos/profile_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/profile_iamge_model.dart';


class ProfileController with ChangeNotifier {

  UserModel? get profile => ProfileRepository.instance.profile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      if(profile == null)return;
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
       ProfileRepository.instance.update(profile!..profileImage=image.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> deleteProfileImage()async {
    await ProfileRepository.instance.update(profile!..profileImage=null);
  }

  Future<void> logOut() async {
    await ProfileRepository.instance.logout();
    await ItemRepository.instance.clear();
    await BoxRepository.instance.clear();
    await LocationRepository.instance.clear();
    await SubscriptionRepository.instance.clear();
  }

  Future<void> deleteAccount() async {

  }
}