import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorUtils {
  static final primaryColor = Color(0xffe25e00);
}

// UI Utilities
void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void showAlertDialog(BuildContext context, String title, String message,
    bool dismissable, void Function() onOk,
    {String buttonText = "OK"}) {
  showDialog(
      context: context,
      barrierDismissible: dismissable,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onOk();
                },
                child: Text(buttonText))
          ],
        );
      });
}

// Validators
class Validators {
  static bool isValidEmail(String? email) {
    return email != null &&
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email);
  }

  static String? emailValidator(String? text) {
    if (text == null) return "Email cannot be empty";
    if (!isValidEmail(text)) return "Invalid Email";
    return null;
  }

  static String? phoneValidator(String? text) {
    if (text == null) return "Phone cannot be empty";
    if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(text)) return "Invalid Phone";
    return null;
  }

  static String? passwordValidator(String? txt) {
    if (txt == null) {
      return "Password length should be at least 6.";
    }
    if (txt.length < 6) {
      return "Password length should be at least 6.";
    }

    if (txt.length > 16) {
      return "Max length is 16.";
    }

    if(txt.contains(" "))
      return "Password cannot have whitespaces";

    if (!RegExp("^(?=.*?[0-9])").hasMatch(txt))
      return "Password should contain 1 digit";

    if (!RegExp("^(?=.*[A-Z])").hasMatch(txt))
      return "Password should contain 1 uppercase letter";

    // if (!RegExp('^(?=.*?[!@#\$&*~])').hasMatch(txt))
    //   return "Password should contain 1 character";
    return null;
  }

  static String? fullNameValidator(String? text) {
    if (text == null) return "Name cannot be empty";
    if (text.trim().split(" ").length != 2)
      return "Enter both first & last names";
    if (RegExp("^(?=.*?[0-9])").hasMatch(text))
      return "Names cannot contain digits";

    return null;
  }
}
