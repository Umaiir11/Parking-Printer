import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../printer_service.dart';
import '../view_model/parking_viewmodel.dart';

class QrDisplayView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Generated QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR Code Container with animation
            Expanded(
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: 5,
                  intensity: 0.8,
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                ),
                padding: EdgeInsets.all(20),
                child: Obx(() => QrImageView(
                  data: vm.qrData.value,
                  version: QrVersions.auto,
                  size: 250,
                  gapless: false,
                )).animate().fadeIn(duration: 800.ms).slide(begin: Offset(0, -30), duration: 800.ms, curve: Curves.easeOut),
              ),
            ),
            SizedBox(height: 20),

            // Print Button with fun animation
            _buildNeumorphicButton(
              text: 'PRINT QR CODE',
              icon: LucideIcons.printer,
              onPressed: () => PrinterService.printQr(vm.qrData.value),
            ).animate().scale( duration: 150.ms).then().scale( duration: 150.ms),
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
