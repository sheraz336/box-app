import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final Function(String) onChanged;
  final String? errorText;
  final TextStyle textStyle;
  final String? Function(String?)? validator;
  final int? maxLength;

  CustomTextFormField(
      {this.maxLength,
      this.validator,
      required this.hintText,
      this.obscureText = false,
      required this.onChanged,
      this.errorText,
      required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle,
        errorText: errorText,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFCFD5DB)),
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffCFD5DB),
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(0xffF33D3D),
          ),
        ),
      ),
    );
  }
}
