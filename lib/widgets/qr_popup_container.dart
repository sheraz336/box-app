import 'dart:io';

import 'package:barcode/barcode.dart';
import 'package:box_delivery_app/models/qr_model.dart';
import 'package:box_delivery_app/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QrPopupContainer extends StatelessWidget {
  final VoidCallback onPrint;
  final VoidCallback onDone;
  final QrModel model;

  const QrPopupContainer({
    Key? key,
    required this.onPrint,
    required this.onDone,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final svgString =
        Barcode.qrCode().toSvg(model.toQrData(), width: 150, height: 150);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Added Successfully" Text
          const Text(
            "Scan or Print Your QR",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          // QR Code Image
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.string(svgString),
          ),

          const SizedBox(height: 50),

          // Print & Done Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Print Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      //generate pdf
                      final pdf = pw.Document();
                      pdf.addPage(pw.Page(build: (pw.Context context) {
                        return pw.Center(
                          child: pw.SvgImage(svg: svgString),
                        ); // Center
                      }));

                      // save file
                      String fileName = model.name() + ".pdf";
                      String? output = await FilePicker.platform.saveFile(
                          bytes: await pdf.save(), fileName: fileName);
                      if (output == null) {
                        throw Exception("Cancelled");
                      }

                      showSnackbar(context, "PDF Saved Successfully");
                    } catch (e) {
                      print(e);
                      showSnackbar(context, e.toString());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xff06a3e0)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Print",
                    // style: TextStyle(
                    //     color: Color(0xff06a3e0), fontWeight: FontWeight.bold),
                    style: TextStyle(color: Color(0xff06a3e0), fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Done Button
              Expanded(
                child: ElevatedButton(
                  onPressed: onDone,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff06a3e0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child:
                      const Text("Done", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
