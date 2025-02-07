import 'package:flutter/material.dart';
import '../models/qr_scan_model.dart';

class QRScanController with ChangeNotifier {
  QRScanModel _model = QRScanModel();

  bool get isValid => _model.isValid;
  bool get isScanning => _model.isScanning;
  String? get qrData => _model.qrData;

  void startScanning() {
    _model.isScanning = true;
    notifyListeners();
  }

  void processQRCode(String? data) {
    _model.qrData = data;
    _model.isValid = data != null && data.isNotEmpty;
    _model.isScanning = false;
    notifyListeners();
  }

  void resetScan() {
    _model = QRScanModel();
    notifyListeners();
  }
}