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

void showConfirmDialog(BuildContext context, String title, String message,
    bool dismissable, void Function() onOk) {
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
                child: const Text("OK")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"))
          ],
        );
      });
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
    if (!RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$').hasMatch(text))
      return "Invalid Phone";
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

    if (txt.contains(" ")) return "Password cannot have whitespaces";

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
    if (text.trim().split(" ").length < 2)
      return "Enter both first & last names";
    if (RegExp("^(?=.*?[0-9])").hasMatch(text))
      return "Names cannot contain digits";
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(text))
      return "Names cannot contain character";

    return null;
  }

  static String? locationValidator(String? text) {
    if (text == null) return "Name cannot be empty";
    if (text.trim().length < 3) return "Min Length is 3";
    if (RegExp("^(?=.*?[0-9])").hasMatch(text.trim()))
      return "Location cannot contain digits";
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(text.trim()))
      return "Location cannot contain character";

    return null;
  }

  static String? addressValidator(String? text) {
    if (text == null) return "Address cannot be empty";
    if (text.trim().length < 10) return "Min Length is 10";
    return null;
  }

  static String? boxNameValidator(String? text) {
    if (text == null) return "Name cannot be empty";
    if (text.trim().length < 3) return "Min Length is 3";
    if (RegExp("^(?=.*?[0-9])").hasMatch(text.trim()))
      return "Box cannot contain digits";
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(text.trim()))
      return "Box cannot contain character";

    return null;
  }

  static String? itemNameValidator(String? text) {
    if (text == null) return "Name cannot be empty";
    if (text.trim().length < 3) return "Min Length is 3";
    if (RegExp("^(?=.*?[0-9])").hasMatch(text.trim()))
      return "Item cannot contain digits";
    if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(text.trim()))
      return "Item cannot contain character";

    return null;
  }

  static String? quantityValidator(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    if (!RegExp(r"^[0-9]+$").hasMatch(text.trim())) return "Enter digits only";
    return null;
  }

  static String? valueValidator(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    if (!RegExp(r"^[0-9]+$").hasMatch(text.trim())) return "Enter digits only";
    return null;
  }

  static String? tagsValidator(String? text) {
    if (text == null || text.trim().isEmpty) return null;
    if (!RegExp(r"^[a-zA-Z,]+$").hasMatch(text.trim()))
      return "Enter tags separated by comma";
    return null;
  }
}
