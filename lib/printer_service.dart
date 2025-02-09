import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:get/get.dart';
import 'package:parkingapp/view_model/bt_printers.dart';
import 'package:parkingapp/models/parking_model.dart'; // Import your ParkingModel

class PrinterService {
  final BTPrintersController _printerController = Get.find<BTPrintersController>();

  /// Prints a professional parking receipt
  Future<void> printReceipt(ParkingModel parking) async {
    final connectedPrinter = _printerController.connectedDevice.value;
    if (connectedPrinter == null) {
      print("No printer connected.");
      return;
    }

    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final generator = Generator(paper, profile);
      List<int> bytes = [];

      // Business Header
      bytes += generator.text(
        'PARKING RECEIPT',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.text(
        'Thank you for using our services',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.hr();

      // Receipt Details
      bytes += generator.text(
        'Vechile Number: ${parking.vehicleNumber}',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.hr();

      // Parking Information Table
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
        PosColumn(text: '50 Rs/hr', width: 6),
      ]);
      bytes += generator.hr();

      // Total Amount
      bytes += generator.text(
        'TOTAL AMOUNT: Rs. ${parking.totalAmount}',
        styles: PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
      );
      bytes += generator.hr();

      // Expiry Status
      bytes += generator.text(
        'Status: ${parking.isActive == true ? "Active" : "Expired"}',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );
      bytes += generator.hr();

      // Important Notice
      bytes += generator.text(
        'Keep this receipt safe. Contact the counter for assistance.',
        styles: PosStyles(align: PosAlign.center),
      );
      bytes += generator.hr();

      // Footer
      bytes += generator.text(
        'Powered by Parking App',
        styles: PosStyles(align: PosAlign.center, bold: true),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      // Send Data to Printer in Chunks
      await _sendToPrinterInChunks(bytes);
    } catch (e) {
      print("Error while printing receipt: $e");
    }
  }

  /// Helper Function to Send Data in Chunks

  Future<void> printQrToken(String qrData) async {
    final connectedPrinter = _printerController.connectedDevice.value;
    if (connectedPrinter == null) {
      print("❌ No printer connected.");
      return;
    }

    try {
      const PaperSize paper = PaperSize.mm80;
      final profile = await CapabilityProfile.load();
      final generator = Generator(paper, profile);
      List<int> bytes = [];

      // 🏢 Title (No emojis, professional)
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

      // 📷 BIGGER QR Code (Maximized to Size 10)
      bytes += generator.qrcode(qrData, size: QRSize.Size8);

      bytes += generator.hr();

      // 📌 Reminder (Polite & Direct)
      bytes += generator.text(
        'Without this token, vehicle retrieval is not possible.\nThank you!',
        styles: PosStyles(align: PosAlign.center),
      );

      bytes += generator.feed(2);
      bytes += generator.cut();

      // 🔥 Send Data in Chunks (Fix Bluetooth buffer issue)
      await _sendToPrinterInChunks(bytes);
    } catch (e) {
      print("⚠️ Error while printing QR Token: $e");
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
