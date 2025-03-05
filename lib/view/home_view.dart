import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkingapp/view/parking_form.dart';
import 'package:parkingapp/view/parking_report_view.dart';
import 'package:parkingapp/view/parking_stats_view.dart';
import 'package:parkingapp/view/printers_view.dart';
import 'package:parkingapp/view/scan_view.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../view_model/parking_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeView extends StatelessWidget {
  final ParkingViewModel vm = Get.put(ParkingViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text('Parking Manager', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 80),
            Icon(
              LucideIcons.car,
              size: 100, // Set the size of the icon
              color: NeumorphicTheme.defaultTextColor(context), // Color of the icon
            ).animate().fadeIn(duration: 500.ms).slide(begin: Offset(0, -30), duration: 600.ms, curve: Curves.easeOut),
            SizedBox(height: 40),

            _neumorphicButton(
              onPressed: () => Get.to(() => ParkingStatsView()),

              text: 'Stats',
              icon: LucideIcons.calculator,
            ),
            SizedBox(height: 20),
            _neumorphicButton(
              onPressed: () => Get.to(() => MonthlyParkingReportView()),

              text: 'Reporting',
              icon: LucideIcons.calendar,
            ),
            SizedBox(height: 20),

            _neumorphicButton(
              onPressed: () => Get.to(() => ParkingFormView()),
              text: 'NEW PARKING',
              icon: LucideIcons.parkingCircle,
            ),
            SizedBox(height: 20),
            _neumorphicButton(
              onPressed: () => Get.to(() => ScanView()),
              text: 'SCAN QR',
              icon: LucideIcons.scan,
            ),SizedBox(height: 20),
            _neumorphicButton(
              onPressed: () => Get.to(() => PrintersAvailableView()),
              text: 'Connect Printer',
              icon: LucideIcons.printer,
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _neumorphicButton({required VoidCallback onPressed, required String text, required IconData icon}) {
    return NeumorphicButton(
      onPressed: onPressed,
      style: NeumorphicStyle(
        depth: 5,
        intensity: 0.8,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24, color: NeumorphicTheme.defaultTextColor(Get.context!)),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().scale( duration: 150.ms).then().scale( duration: 150.ms); // Boom effect
  }
}
