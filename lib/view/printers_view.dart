import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../view_model/bt_printers.dart';

class PrintersAvailableView extends StatelessWidget {
  final BTPrintersController controller = Get.find<BTPrintersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Printers")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: controller.scanForPrinters,
            child: Text("Scan for Printers"),
          ),
          Expanded(
            child: Obx(() {
              if (controller.availablePrinters.isEmpty) {
                return Center(child: Text("No Printers Found"));
              }

              return ListView.builder(
                itemCount: controller.availablePrinters.length,
                itemBuilder: (context, index) {
                  BluetoothDevice printer = controller.availablePrinters[index];

                  return ListTile(
                    title: Text(printer.name.isEmpty ? "Unknown Printer" : printer.name),
                    subtitle: Text(printer.id.toString()),
                    trailing: Obx(() => controller.connectedDevice.value == printer
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.bluetooth, color: Colors.blue)),
                    onTap: () => controller.connectToPrinter(printer),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
