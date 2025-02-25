import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:parkingapp/view_model/bt_printers.dart';
import 'package:parkingapp/models/parking_model.dart'; // Import your ParkingModel

class PrinterService {
  final BTPrintersController _printerController = Get.find<BTPrintersController>();

  /// Prints a professional parking receipt
  Future<bool> printReceipt(ParkingModel parking) async {
    // 🚀 Check Bluetooth Adapter State Before Proceeding
    var state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      print("Bluetooth is OFF. Cannot print receipt.");
      return false;
    }

    final connectedPrinter = _printerController.connectedDevice.value;
    if (connectedPrinter == null) {
      print("No printer connected.");
      return false;
    }

    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final generator = Generator(paper, profile);
      List<int> bytes = [];

      // 🏢 Business Header
      bytes += generator.text(
        'PARKING RECEIPT',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.text(
        'Thank you for using our services',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.hr();

      // 🚗 Vehicle Information
      bytes += generator.row([
        PosColumn(text: 'Vehicle Number', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: parking.vehicleNumber ?? "N/A", width: 6),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Entry Time', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: parking.entryTime.toString(), width: 6),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Exit Time', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: parking.exitTime?.toString() ?? 'N/A', width: 6),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Total Duration', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: _calculateDuration(parking), width: 6),
      ]);
      bytes += generator.row([
        PosColumn(text: 'Rate Per Hour', width: 6, styles: PosStyles(bold: true)),
        PosColumn(text: '50 \$ per hour', width: 6),
      ]);
      bytes += generator.hr();

      // 💰 Total Amount (Bold & Highlighted)
      bytes += generator.text(
        'TOTAL AMOUNT: Rs. ${parking.totalAmount}',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.hr();

      // ⏳ Status (Active or Expired)
      bytes += generator.text(
        'Status: ${parking.isActive == true ? "Active" : "Expired"}',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.hr();

      // ⚠️ Important Notice
      bytes += generator.text(
        'Keep this receipt safe. Contact the counter for assistance.',
        styles: PosStyles(align: PosAlign.center),
      );
      bytes += generator.hr();

      // 📞 Contact Number (Bold & Clearly Visible)
      bytes += generator.text(
        'For Assistance & Details:',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.text(
        '+971 54 752 0740',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );

      bytes += generator.hr();

      // 🌍 Designed & Developed By (Professional Branding)
      bytes += generator.text(
        'Designed & Developed by',
        styles: PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(
        'www.devcruise.co',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      // 🔥 Send Data to Printer in Chunks (Prevents Buffer Overload)
      await _sendToPrinterInChunks(bytes);

      return true; // ✅ Successfully printed
    } catch (e) {
      print("Error while printing receipt: $e");
      return false; // ❌ Failed to print
    }
  }

  /// Helper Function to Send Data in Chunks

  Future<bool> printQrToken(String qrData) async {
    // 🚀 Check Bluetooth Adapter State Before Proceeding
    var state = await FlutterBluePlus.adapterState.first;
    if (state != BluetoothAdapterState.on) {
      print("❌ Bluetooth is OFF. Cannot print QR Token.");
      return false;
    }

    final connectedPrinter = _printerController.connectedDevice.value;
    if (connectedPrinter == null) {
      print("❌ No printer connected.");
      return false;
    }

    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final generator = Generator(paper, profile);
      List<int> bytes = [];

      // 🏢 Title (Bold, Large, Centered)
      bytes += generator.text(
        'PARKING TOKEN',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.hr();

      // 📜 Instructions (Concise & Clear)
      bytes += generator.text(
        'Keep this token safe & return it at the counter to retrieve your vehicle.',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.hr();

      // 📷 BIGGER QR Code (Maximized)
      bytes += generator.qrcode(qrData, size: QRSize.Size8);

      bytes += generator.hr();

      // 📌 Reminder (Polite & Direct)
      bytes += generator.text(
        'Without this token, vehicle retrieval is not possible.\nThank you!',
        styles: PosStyles(align: PosAlign.center),
      );

      bytes += generator.hr();

      // 📞 Contact for Complaints & Queries (Bold & Professional)
      bytes += generator.text(
        'For Complaints & Queries:',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.text(
        '+971 55 661 3239',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );

      bytes += generator.hr();

      // ⚡ Powered By (Professional Branding)
      bytes += generator.text(
        'Designed & Developed by',
        styles: PosStyles(align: PosAlign.center),
      );
      bytes += generator.text(
        'www.devcruise.co',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      // 🔥 Send Data in Chunks (Fix Bluetooth buffer issue)
      await _sendToPrinterInChunks(bytes);
      return true;
    } catch (e) {
      print("⚠️ Error while printing QR Token: $e");
      return false;
    }
  }

  /// Helper Function to Send Data in Chunks
  Future<void> _sendToPrinterInChunks(List<int> bytes) async {
    const int chunkSize = 200; // Keep it below 237 bytes
    for (var i = 0; i < bytes.length; i += chunkSize) {
      final chunk = bytes.sublist(i, i + chunkSize > bytes.length ? bytes.length : i + chunkSize);
      await _sendToPrinter(chunk);
      await Future.delayed(Duration(milliseconds: 50)); // Small delay for stability
    }
  }

  /// Helper Function to Send Data in Chunks

  /// Sends the print job to the printer
  Future<void> _sendToPrinter(List<int> bytes) async {
    final connectedPrinter = _printerController.connectedDevice.value;
    if (connectedPrinter == null) {
      print("❌ No printer connected.");
      return;
    }

    BluetoothCharacteristic? characteristic = await _findWriteCharacteristic(connectedPrinter);
    if (characteristic != null) {
      await characteristic.write(Uint8List.fromList(bytes), withoutResponse: false);
      print("✅ Print job sent successfully.");
    } else {
      print("❌ No writable characteristic found.");
    }
  }

  /// Finds a writable characteristic for sending print data
  Future<BluetoothCharacteristic?> _findWriteCharacteristic(BluetoothDevice device) async {
    try {
      List<BluetoothService> services = await device.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.write) {
            return characteristic;
          }
        }
      }
    } catch (e) {
      print("⚠️ Error finding write characteristic: $e");
    }
    return null;
  }

  /// Calculate parking duration
  String _calculateDuration(ParkingModel parking) {
    final entry = parking.entryTime ?? DateTime.now();
    final exit = parking.exitTime ?? DateTime.now();
    final duration = exit.difference(entry);

    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
}
