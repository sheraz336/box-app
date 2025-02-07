class QRScanModel {
  String? qrData;
  bool isValid;
  bool isScanning;

  QRScanModel({
    this.qrData,
    this.isValid = true,
    this.isScanning = false,
  });
}