import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/forget_pass_controller.dart';

class OTPInput extends StatelessWidget {
  const OTPInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => SizedBox(
          width: 50,
          height: 50,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < 3) {
                FocusScope.of(context).nextFocus();
              }
              // Update OTP in controller
              context.read<AuthController>().setOTP(value);
            },
          ),
        ),
      ),
    );
  }
}
