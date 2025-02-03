import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../printer_service.dart';
import '../view_model/parking_viewmodel.dart';

class ReceiptView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Receipt')),
      body: Column(
        children: [
          ListTile(
            title: Text('Vehicle Number'),
            subtitle: Text(vm.currentParking.value.vehicleNumber ?? ''),
          ),
          // Add other receipt details
          ElevatedButton(
            onPressed: () => PrinterService.printReceipt(vm.currentParking.value),
            child: Text('PRINT RECEIPT'),
          ),
        ],
      ),
    );
  }
}