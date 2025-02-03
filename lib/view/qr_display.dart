import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../printer_service.dart';
import '../view_model/parking_viewmodel.dart';

class QrDisplayView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generated QR')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => QrImageView(
              data: vm.qrData.value,
              version: QrVersions.auto,
              size: 300,
            )),
          ),
          ElevatedButton(
            onPressed: () => PrinterService.printQr(vm.qrData.value),
            child: Text('PRINT QR CODE'),
          ),
        ],
      ),
    );
  }
}