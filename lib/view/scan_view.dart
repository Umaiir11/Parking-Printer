import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../view_model/parking_viewmodel.dart';
import 'receipt_view.dart';

class ScanView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Scan QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Neumorphic(
                style: NeumorphicStyle(
                  depth: -4,
                  boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                ),
                child: MobileScanner(
                  onDetect: (barcodeCapture) async {
                    final List<Barcode> barcodes = barcodeCapture.barcodes;
                    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                      vm.qrData.value = barcodes.first.rawValue!;
                      await vm.completeParking();
                      Get.to(() => ReceiptView());
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildNeumorphicButton(
              text: 'Cancel',
              icon: LucideIcons.xCircle,
              onPressed: () => Get.back(),
            ),
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
