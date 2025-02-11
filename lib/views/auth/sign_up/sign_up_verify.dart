import 'package:box_delivery_app/utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/verification_controller.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textform.dart';
import 'sign_up_otp.dart';

class VerificationView extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final verificationController = Provider.of<VerificationController>(context);

    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                const Text(
                  "Verify your \nphone number",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff182035)),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "We have send you an ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff606268),
                          decoration: TextDecoration.none,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                      TextSpan(
                        text: "One Time Password(OTP)\n",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff313646),
                          decoration: TextDecoration.none,
                        ),
                      ),
                      TextSpan(
                        text: "on this mobile number ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff606268),
                          decoration: TextDecoration.none,
                          textBaseline: TextBaseline.alphabetic,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 40),
                Text(
                  'Enter mobile no.*',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Color(0xff747474)),
                ),
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffD9D9D9)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CountryCodePicker(
                            showFlag: false,
                            initialSelection: "GB",
                            onChanged: (c) {
                              if (c.code == null) return;
                              print(c.code);
                              verificationController
                                  .updateCountryCode(c.dialCode!);
                            })),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomTextFormField(
                        hintText: "",
                        maxLength: 11,
                        textStyle: const TextStyle(color: Colors.black54),
                        onChanged: verificationController.updatePhoneNumber,
                        validator: (text) {
                          print(verificationController.fullPhoneNumber);
                          return Validators.phoneValidator(
                              verificationController.fullPhoneNumber);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                CustomButton(
                  text: "Get OTP",
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen()));
                  },
                ),
              ],
            ),
          )),
    );
  }
}
