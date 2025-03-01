import 'package:box_delivery_app/models/profile_iamge_model.dart';
import 'package:box_delivery_app/repos/profile_repository.dart';
import 'package:box_delivery_app/repos/subscription_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/login_model.dart';

class AuthController extends ChangeNotifier {
  final AuthModel authModel = AuthModel();
  bool _isSigningIn = false;

  bool get isSigningIn => _isSigningIn;

  void setEmail(String email) {
    authModel.email = email.trim();
    notifyListeners();
  }

  void setPassword(String password) {
    authModel.password = password.trim();
    notifyListeners();
  }

  Future<void> signIn() async {
    if (isSigningIn) {
      return;
    }
    try {
      _isSigningIn = true;
      notifyListeners();

      //login
      await FirebaseAuth.instance.signOut();
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: authModel.email, password: authModel.password);

      //save profile
      final userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userCred.user!.uid)
          .get();
      final userData = userSnapshot.data()!;

      //save proile
      ProfileRepository.instance.update(UserModel(
          name: userData["name"],
          email: userData["email"],
          password: authModel.password,
          phoneNumber: userData["phone"] ?? "______"));

      //get subscription
      final subSnapshot = await FirebaseFirestore.instance
          .collection("subscriptions")
          .doc(userCred.user!.uid)
          .get();
      if (subSnapshot.exists) {
        SubscriptionRepository.instance.changeTo(subSnapshot.data()!["id"],
            expiry: DateTime.fromMillisecondsSinceEpoch(
                subSnapshot.data()!["expiryTime"],
                isUtc: true));
      }

      _isSigningIn = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      await FirebaseAuth.instance.signOut();
      _isSigningIn = false;
      notifyListeners();
      print("Firebae auth exception ${e.code} $e");

      switch (e.code) {
        case 'invalid-email':
          throw Exception('The email address is not valid.');
        case 'user-disabled':
          throw Exception('This user has been disabled.');
        case 'user-not-found':
          throw Exception('No user found with this email.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'too-many-requests':
          throw Exception('Too many attempts. Try again later.');
        case 'operation-not-allowed':
          throw Exception('Signing in with email and password is not enabled.');
        case 'invalid-credential':
          throw Exception('Invalid Credentials');
        default:
          throw Exception('An unknown error occurred: ${e.message}');
      }
    } catch (e) {
      await FirebaseAuth.instance.signOut();
      _isSigningIn = false;
      notifyListeners();

      print('An unexpected error occurred: $e');
      throw e;
    }
  }

  Future<bool> signInWithGoogle() async {
    await FirebaseAuth.instance.signOut();
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // User canceled the sign-in
      return false;
    }

    //sign in user
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    //create user if does not exist in 'users' collection
    final snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .get();
    if (!snapshot.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        "name": userCredential.user?.displayName ?? "Your Name",
        "email": userCredential.user!.email,
      });
    }
    return true;
  }
}
