import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../printer_service.dart';
import '../view_model/parking_viewmodel.dart';

class ReceiptView extends StatelessWidget {
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
            _buildReceiptTile('Vehicle Number', vm.currentParking.value.vehicleNumber),
            _buildReceiptTile('Owner Name', vm.currentParking.value.ownerName),
            _buildReceiptTile('Phone Number', vm.currentParking.value.phoneNumber),
            _buildReceiptTile('ID Card Number', vm.currentParking.value.idCardNumber),

            SizedBox(height: 30),
            _buildNeumorphicButton(
              text: 'PRINT RECEIPT',
              icon: LucideIcons.printer,
              onPressed: () => PrinterService.printReceipt(vm.currentParking.value),
            ),
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
