import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../view_model/parking_viewmodel.dart';
import 'receipt_view.dart'; // Ensure you import ReceiptView

class ScanView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (barcodeCapture) async {
                final List<Barcode> barcodes = barcodeCapture.barcodes;
                if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                  vm.qrData.value = barcodes.first.rawValue!;
                  await vm.completeParking();
                  Get.to(() => ReceiptView());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
