import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parkingapp/view/qr_display.dart';
import '../view_model/parking_viewmodel.dart';

class ParkingFormView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'New Parking',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildNeumorphicTextField(
              label: 'Vehicle Number',
              icon: LucideIcons.car,
              onChanged: (v) => vm.currentParking.value.vehicleNumber = v,
            ),
            _buildNeumorphicTextField(
              label: 'Owner Name',
              icon: LucideIcons.user,
              onChanged: (v) => vm.currentParking.value.ownerName = v,
            ),
            _buildNeumorphicTextField(
              label: 'Phone Number',
              icon: LucideIcons.phone,
              onChanged: (v) => vm.currentParking.value.phoneNumber = v,
            ),
            _buildNeumorphicTextField(
              label: 'ID Card Number',
              icon: LucideIcons.badgePercent,
              onChanged: (v) => vm.currentParking.value.idCardNumber = v,
            ),
            SizedBox(height: 20),
            Obx(() => vm.isLoading.value
                ? NeumorphicProgress(
                    percent: 0.5,
                    height: 10,
                    style: ProgressStyle(depth: 5),
                  )
                : _buildNeumorphicButton(
                    text: 'GENERATE QR',
                    icon: LucideIcons.qrCode,
                    onPressed: () async {
                      await vm.createNewParking();
                      Get.to(() => QrDisplayView());
                    },
                  )),
          ],
        ),
      ),
    );
  }

  /// **Neumorphic TextField with Icon**
  Widget _buildNeumorphicTextField({
    required String label,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -4,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            Icon(icon, color: NeumorphicTheme.defaultTextColor(Get.context!)),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: label,
                  labelStyle: TextStyle(color: NeumorphicTheme.defaultTextColor(Get.context!)),
                ),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Neumorphic Button with Icon**
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
