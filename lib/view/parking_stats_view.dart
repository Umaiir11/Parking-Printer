import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../view_model/parking_viewmodel.dart';


class ParkingStatsView extends StatefulWidget {
  @override
  State<ParkingStatsView> createState() => _ParkingStatsViewState();
}

class _ParkingStatsViewState extends State<ParkingStatsView> {
  final ParkingViewModel vm = Get.put(ParkingViewModel());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vm.fetchParkingStats();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parking Stats")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return 
            vm.isFetching.value?
                Center(child: CupertinoActivityIndicator()):
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures only necessary space is taken
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildStatCard(
                    title: "Total Slots",
                    value: vm.totalSlots.value.toString(),
                    icon: LucideIcons.parkingSquare,
                    color: Colors.blue,
                  ).animate().fade(duration: 400.ms).slideY(),

                  SizedBox(height: 16),

                  _buildStatCard(
                    title: "Total In",
                    value: vm.totalIn.value.toString(),
                    icon: LucideIcons.arrowDownCircle,
                    color: Colors.green,
                  ).animate().fade(duration: 500.ms).slideY(),

                  SizedBox(height: 16),

                  _buildStatCard(
                    title: "Total Out",
                    value: vm.totalOut.value.toString(),
                    icon: LucideIcons.arrowUpCircle,
                    color: Colors.red,
                  ).animate().fade(duration: 600.ms).slideY(),
                ],
              ),
            );
        }),
      ),
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Neumorphic(
      style: NeumorphicStyle(
        depth: 6,
        intensity: 0.9,
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
        color: NeumorphicTheme.baseColor(Get.context!),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 36, color: color),
          SizedBox(height: 10),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    ).animate().scale(duration: 300.ms);
  }
}
