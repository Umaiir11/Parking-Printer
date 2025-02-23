import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../view_model/bt_printers.dart';

class PrintersAvailableView extends StatelessWidget {
  final BTPrintersController controller = Get.find<BTPrintersController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Available Printers")),
      body: Column(
        children: [
          _neumorphicButton(
            onPressed: () async {
              bool isScanningStarted = await controller.scanForPrinters();
              if (!isScanningStarted) {
                Get.snackbar(
                  "Bluetooth Off",
                  "Please turn on your Bluetooth to scan for printers.",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            text: 'Scan for Printers',
            icon: LucideIcons.parkingCircle,
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
                    trailing: Obx(() => controller.connectedDevice.value == printer ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.bluetooth, color: Colors.blue)),
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

  Widget _neumorphicButton({required VoidCallback onPressed, required String text, required IconData icon}) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 5,
        intensity: 0.8,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: NeumorphicTheme.defaultTextColor(Get.context!)),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().scale(duration: 150.ms).then().scale(duration: 150.ms); // Boom effect
  }
}
