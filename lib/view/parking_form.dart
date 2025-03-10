import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:parkingapp/view/qr_display.dart';
import '../view_model/parking_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ParkingFormView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'New Parking',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAnimatedTextField(
                keyboardType: TextInputType.number,
                icon: LucideIcons.user, // User Icon
                label: 'Rate per hour',
                onChanged: (v) => vm.perHourPRate.value = v,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5),
                child: Text(
                  "If you leave this field empty, the parking per hour rate will be 5 AED.",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ).animate().scale(duration: 300.ms).fadeIn(duration: 500.ms, delay: 600.ms).slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
              Divider(
                color: Colors.grey,
                // Set the color to grey
                thickness: 1,
                endIndent: 50,
                indent: 50,
                // Adjust thickness if needed
                height: 20, // Space above and below the divider
              ).animate().scale(duration: 300.ms).fadeIn(duration: 500.ms, delay: 600.ms).slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
              _buildAnimatedTextField(
                icon: LucideIcons.car,
                // Car Icon
                label: 'Vehicle Number',
                onChanged: (v) => vm.currentParking.value.vehicleNumber = v,
                isRequired: true,
                errorMsg: 'Vehicle number is required',
              ),
              _buildAnimatedTextField(
                icon: LucideIcons.user, // User Icon
                label: 'Owner Name',
                onChanged: (v) => vm.currentParking.value.ownerName = v,
              ),
              _buildAnimatedTextField(
                icon: LucideIcons.phone,
                // Phone Icon
                label: 'Phone Number',
                onChanged: (v) => vm.currentParking.value.phoneNumber = v,
              ),
              _buildAnimatedTextField(
                icon: LucideIcons.badgeCheck, // ID Card Icon
                label: 'ID Card Number',
                onChanged: (v) => vm.currentParking.value.idCardNumber = v,
              ),
              SizedBox(height: 20),
              Obx(
                    () => vm.isLoading.value
                    ? NeumorphicProgress(
                  percent: 0.5,
                  height: 10,
                  style: ProgressStyle(depth: 5),
                ).animate().scale(duration: 400.ms).fadeIn(duration: 500.ms)
                    : _buildAnimatedButton(
                  text: 'GENERATE QR',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool hasSlots = await vm.createNewParking();
                      if (hasSlots) {
                        Get.to(() => QrDisplayView());
                      } else {
                        Get.snackbar(
                          "Parking Full",
                          "No parking slots available right now.",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    }
                  },
                  icon: LucideIcons.qrCode, // QR Code Icon
                ).animate().scale(duration: 300.ms).fadeIn(duration: 500.ms, delay: 600.ms).slide(begin: Offset(-30, 0), duration: 500.ms, curve: Curves.easeOutCubic),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required IconData icon,
    required String label,
    required ValueChanged<String> onChanged,
    bool isRequired = false,
    String? errorMsg,
    TextInputType? keyboardType, // Nullable keyboardType
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: -4,
          intensity: 0.8,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextFormField(
          keyboardType: keyboardType, // Nullable: Uses default if not provided
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(
              color: NeumorphicTheme.defaultTextColor(Get.context!).withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: Icon(icon, color: NeumorphicTheme.defaultTextColor(Get.context!)), // Icon added here
          ),
          validator: isRequired ? (value) => value == null || value.isEmpty ? errorMsg : null : null,
          onChanged: onChanged,
        ),
      ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slide(begin: const Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic).scale(duration: 300.ms),
    );
  }

  Widget _buildAnimatedButton({required String text, required VoidCallback onPressed, required IconData icon}) {
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black), // Icon added
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 500.ms)
        .scale(duration: 300.ms)
        .slide(begin: Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic)
        .shimmer(duration: 800.ms, color: Colors.blue);
  }
}