import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'models/parking_model.dart';

class PrinterService {
  static Future<void> printReceipt(ParkingModel parking) async {
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.text('PARKING RECEIPT',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.hr();
    bytes += generator.text('Vehicle: ${parking.vehicleNumber}');
    bytes += generator.text('Duration: ${_calculateDuration(parking)} days');
    bytes += generator.text('Total: ₹${parking.totalAmount}');
    bytes += generator.feed(2);
    bytes += generator.cut();

    await _sendToPrinter(bytes);
  }

  static Future<void> printQr(String qrData) async {
    // Implement your QR code printing logic here.
    // For example, if you generate a QR image and convert it to bytes, use similar steps as below:
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final generator = Generator(paper, profile);
    List<int> bytes = [];

    // Add a title for the QR section
    bytes += generator.text('QR CODE',
        styles: PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.hr();

    // For demonstration, we're using the QR data string directly.
    // In a real scenario, you might generate a QR image and then print it.
    bytes += generator.text(qrData,
        styles: PosStyles(align: PosAlign.center));

    // Feed and cut the receipt
    bytes += generator.feed(2);
    bytes += generator.cut();

    await _sendToPrinter(bytes);
  }

  static Future<void> _sendToPrinter(List<int> bytes) async {
    // Implement printer connection logic here.
    // For example, connect via Bluetooth using iTech Goojprt PT210 Bluetooth connection.
  }

  /// Calculates the duration of parking in days.
  /// If [parking.exitTime] is not set, it uses the current time.
  static int _calculateDuration(ParkingModel parking) {
    // Ensure your ParkingModel has entryTime and optionally exitTime as DateTime.
    final DateTime start = parking.entryTime ?? DateTime.now();
    final DateTime end = parking.exitTime ?? DateTime.now();

    // Calculate the difference in days.
    int days = end.difference(start).inDays;

    // If the difference is less than 1 day but some time has passed, count it as 1 day.
    if (days == 0 && end.isAfter(start)) {
      return 1;
    }
    return days;
  }
}
