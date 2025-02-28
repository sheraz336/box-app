import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/signup_model.dart';

class UserController with ChangeNotifier {
  UserModel _user = UserModel();
  bool _isSigningUp = false;

  bool get isSigningUp => _isSigningUp;

  UserModel get user => _user;

  void updateName(String value) {
    _user.name = value.trim();
    notifyListeners();
  }

  void updateEmail(String value) {
    _user.email = value.trim();
    notifyListeners();
  }

  void updatePassword(String value) {
    _user.password = value;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _user.confirmPassword = value;
    notifyListeners();
  }

  void updatePhoneNumber(String value) {
    _user.phoneNumber = value.trim();
  }

  Future<void> signUp() async {
    if (_isSigningUp) {
      return;
    }
    try {
      _isSigningUp = true;
      notifyListeners();

      //create user
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email, password: user.password);

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email, password: user.password);

      //create user in database
      await FirebaseFirestore.instance
          .collection("users")
          .doc(cred.user!.uid)
          .set({
        "name": user.name,
        "email": user.email,
        "phone":user.phoneNumber,
      });

      _isSigningUp = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isSigningUp = false;
      notifyListeners();
      print("Firebae auth exception ${e.code} $e");

      switch (e.code) {
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'email-already-in-use':
          throw Exception('Email already in use.');
        case 'too-many-requests':
          throw Exception('Too many attempts. Try again later.');
        case 'operation-not-allowed':
          throw Exception('Signing in with email and password is not enabled.');
        case 'weak-password':
          throw Exception('Your password is weak');
        default:
          throw Exception('An unknown error occurred: ${e.message}');
      }
    } catch (e) {
      _isSigningUp = false;
      notifyListeners();

      print('An unexpected error occurred: $e');
      throw e;
    }
  }
}
