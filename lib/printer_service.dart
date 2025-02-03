import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'models/parking_model.dart';

class PrinterService {
  static Future<void> printReceipt(ParkingModel parking) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    // Add the title and styles
    bytes += generator.text('PARKING RECEIPT',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.hr();

    // Add the parking details
    bytes += generator.text('Vehicle: ${parking.vehicleNumber}');
    bytes += generator.text('Duration: ${_calculateDuration(parking)}');
    bytes += generator.text('Total: ₹${parking.totalAmount}');

    bytes += generator.feed(2);
    bytes += generator.cut();

    await _sendToPrinter(bytes);
  }

  static Future<void> printQr(String qrData) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    // Add a title for the QR section
    bytes += generator.text('QR CODE',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.hr();

    // Print QR data (string representation for now)
    bytes += generator.text(qrData,
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.feed(2);
    bytes += generator.cut();

    await _sendToPrinter(bytes);
  }

  static Future<void> _sendToPrinter(List<int> bytes) async {
    // Implement printer connection logic here (e.g., Bluetooth connection to the iTech Goojprt PT210).
  }

  /// Calculates the parking duration in days, hours, and minutes.
  static String _calculateDuration(ParkingModel parking) {
    final DateTime start = parking.entryTime ?? DateTime.now();
    final DateTime end = parking.exitTime ?? DateTime.now();

    final Duration duration = end.difference(start);

    // Get days, hours, and minutes from the duration
    final int days = duration.inDays;
    final int hours = duration.inHours % 24;
    final int minutes = duration.inMinutes % 60;

    // Format the result based on duration in days, hours, and minutes
    String durationStr = '';
    if (days > 0) {
      durationStr += '$days day${days > 1 ? 's' : ''} ';
    }
    if (hours > 0) {
      durationStr += '$hours hour${hours > 1 ? 's' : ''} ';
    }
    if (minutes > 0 || (days == 0 && hours == 0)) {
      durationStr += '$minutes minute${minutes > 1 ? 's' : ''}';
    }

    return durationStr.trim();
  }
}
