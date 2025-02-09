import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BTPrintersController extends GetxController {
  var availablePrinters = <BluetoothDevice>[].obs;
  var isScanning = false.obs;
  var isConnecting = false.obs;
  var connectedDevice = Rxn<BluetoothDevice>();

  @override
  void onInit() {
    super.onInit();
    requestBluetoothPermissions();
  }

  /// Request Bluetooth & Location permissions
  Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (!allGranted) {
      Get.snackbar("Permissions Required", "Bluetooth & Location permissions are required.",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
    return allGranted;
  }

  /// Start scanning for Bluetooth printers
  Future<void> scanForPrinters() async {
    if (isScanning.value) return; // Avoid duplicate scans

    bool permissionsGranted = await requestBluetoothPermissions();
    if (!permissionsGranted) return;

    availablePrinters.clear();
    isScanning.value = true;

    FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (!availablePrinters.any((device) => device.id == r.device.id)) {
          availablePrinters.add(r.device);
        }
      }
    });

    await Future.delayed(Duration(seconds: 5));
    isScanning.value = false;
  }

  /// Connect to selected Bluetooth printer
  Future<void> connectToPrinter(BluetoothDevice device) async {
    try {
      isConnecting.value = true;
      await device.connect(autoConnect: false);
      connectedDevice.value = device;

      Get.snackbar("Printer Connected", "Successfully connected to ${device.name}",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Connection Failed", "Error: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isConnecting.value = false;
    }
  }

  /// Disconnect from currently connected printer
  Future<void> disconnectPrinter() async {
    if (connectedDevice.value != null) {
      await connectedDevice.value!.disconnect();
      connectedDevice.value = null;

      Get.snackbar("Printer Disconnected", "Successfully disconnected.",
          backgroundColor: Colors.orange, colorText: Colors.white);
    }
  }
}
