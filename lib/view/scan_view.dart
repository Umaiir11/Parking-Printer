import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../view_model/parking_viewmodel.dart';
import '../widgets/dialog.dart';
import 'receipt_view.dart';

class ScanView extends StatefulWidget {
  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  final ParkingViewModel vm = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm.isProcessing.value = false; // Reset flag when returning

  }
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
              child: Container(
                constraints: BoxConstraints(minHeight: 200, minWidth: 200), // Ensure valid size

                child: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 4, // Avoid negative depth
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 300, // Ensure it's not collapsing
                    child: MobileScanner(
                      onDetect: (barcodeCapture) async {
                        if (vm.isProcessing.value) return; // Prevent multiple calls

                        final List<Barcode> barcodes = barcodeCapture.barcodes;
                        if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                          vm.isProcessing.value = true; // Set flag to prevent repeated execution

                          vm.qrData.value = barcodes.first.rawValue!;
                          bool isActive = await vm.completeParking();

                          if (isActive) {

                            await Get.off(() => ReceiptView());
                            vm.isProcessing.value = false; // Reset flag when returning

                            // Get.to(() => ReceiptView())?.then((_) {
                            //   vm.isProcessing.value = false; // Reset flag when returning
                            // });
                          } else {
                            // Get.snackbar(
                            //   "QR Expired",
                            //   "This QR code has expired. Please generate a new one.",
                            //   snackPosition: SnackPosition.BOTTOM,
                            //   backgroundColor: Colors.red,
                            //   colorText: Colors.white,
                            // );

                            showQRExpiredDialog();
                            Future.delayed(Duration(seconds: 2), () {
                              vm.isProcessing.value = false; // Reset flag after a delay
                            });
                          }
                        }
                      },
                    ),
                  ),

                ).animate().fadeIn(duration: 600.ms).slide(begin: Offset(0, 30), duration: 600.ms, curve: Curves.easeOut),
              ),
            ),
            SizedBox(height: 30),
            _buildNeumorphicButton(
              text: 'Cancel',
              icon: LucideIcons.xCircle,
              onPressed: () => Get.back(),
            ).animate().scale(duration: 150.ms).then().scale(duration: 150.ms), // Fun "boom" effect
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
