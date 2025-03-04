import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import for animations

import '../printer_service.dart';
import '../view_model/parking_viewmodel.dart';

class ReceiptView extends StatefulWidget {
  @override
  State<ReceiptView> createState() => _ReceiptViewState();
}

class _ReceiptViewState extends State<ReceiptView> {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Receipt',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animating each receipt tile
            _buildReceiptTile('Vehicle Number', vm.currentParking.value.vehicleNumber)
                .animate()
                .fadeIn(duration: 500.ms, delay: 800.ms)
                .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
            _buildReceiptTile('Owner Name', vm.currentParking.value.ownerName)
                .animate()
                .fadeIn(duration: 500.ms, delay: 600.ms)
                .slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
            _buildReceiptTile('Phone Number', vm.currentParking.value.phoneNumber)
                .animate()
                .fadeIn(duration: 500.ms, delay: 1000.ms)
                .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic),

            _buildReceiptTile('Entry Time', _formatDate(vm.currentParking.value.entryTime))
                .animate()
                .fadeIn(duration: 500.ms, delay: 1000.ms)
                .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic),

            _buildReceiptTile('Exit Time', _formatDate(vm.currentParking.value.exitTime))
                .animate()
                .fadeIn(duration: 500.ms, delay: 1000.ms)
                .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic),

            _buildReceiptTile('ID Card Number', vm.currentParking.value.idCardNumber)
                .animate()
                .fadeIn(duration: 500.ms, delay: 1200.ms)
                .slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
            _buildReceiptTile('Parking Duration', vm.currentParking.value.parkingDuration)
                .animate()
                .fadeIn(duration: 500.ms, delay: 1400.ms)
                .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
            _buildReceiptTile('Total', vm.currentParking.value.totalAmount.toString())
                .animate()
                .fadeIn(duration: 500.ms, delay: 1600.ms)
                .slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),

            SizedBox(height: 30),
            _buildNeumorphicButton(
              text: 'PRINT RECEIPT',
              icon: LucideIcons.printer,
              onPressed: () async {
                bool isPrinted = await PrinterService().printReceipt(vm.currentParking.value);

                if (isPrinted) {
                  Get.snackbar(
                    "Success",
                    "Receipt printed successfully.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    "Printer Not Connected",
                    "Before printing, you must connect a printer from the home screen.",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ).animate().fadeIn(duration: 500.ms, delay: 1800.ms),
          ],
        ),
      ),
    );
  }

  /// **Neumorphic Styled Receipt Tile**
  Widget _buildReceiptTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 4,
          intensity: 0.8,
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(value ?? 'N/A', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) return "--/--/-- --:-- --";
    return DateFormat("dd/MM/yy - hh:mm a").format(dateTime);
  }

  /// **Neumorphic Button**
  Widget _buildNeumorphicButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 5,
        intensity: 0.9,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
