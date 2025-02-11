import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/qr_scan_controller.dart';

class InvalidQRScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QRScanController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffE25E00),
            leading: Icon(
              Icons.arrow_back_ios,
              color: Color(0xffFFFFFF),
              size: 18,
            ),
            title: Text(
              'Scan QR code',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffFFFFFF)),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: 192.19,
                    height: 191.8,
                    child: Center(
                      child: Image.asset(
                        'assets/invalid_qr.png',
                        width: 192.19,
                        height: 191.8,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'Invalid QR Code',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff21252C)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please ensure the QR code is readable and\ntry scanning again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff76889A),
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 50),
                  CustomButton(text: 'Scan Again', onPressed: () {})
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
