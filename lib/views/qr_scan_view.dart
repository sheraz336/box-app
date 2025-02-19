import 'package:box_delivery_app/views/invalid_qr_view.dart';
import 'package:box_delivery_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/qr_scan_controller.dart';

class QRScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QRScanController>(
      builder: (context, controller, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xffE25E00),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'QR Scan',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffFFFFFF)),
            ),
            centerTitle: true,
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
                    width: 263,
                    height: 264,
                    child: Center(
                      child: Image.asset(
                        'assets/qr_scan.png',
                        width: 224,
                        height: 224,
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  CustomButton(
                      text: 'Scan Item',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InvalidQRScreen()));
                      })
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
