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

import 'all_parking_view.dart';

class HomeView extends StatelessWidget {
  final ParkingViewModel vm = Get.put(ParkingViewModel());

  // Define feature tiles with their associated properties
  final List<Map<String, dynamic>> featureTiles = [
    {
      'title': 'New Parking',
      'icon': LucideIcons.parkingCircle,
      'color': Color(0xFFF5F9FF),
      'accentColor': Color(0xFF2C5282),
      'onTap': () => Get.to(() => ParkingFormView()),
    },
    {
      'title': 'Scan QR',
      'icon': LucideIcons.scan,
      'color': Color(0xFFF5FFF7),
      'accentColor': Color(0xFF276749),
      'onTap': () => Get.to(() => ScanView()),
    },
    {
      'title': 'Search Vehicle',
      'icon': LucideIcons.search,
      'color': Color(0xFFFFFAF5),
      'accentColor': Color(0xFF9C4221),
      'onTap': () => Get.to(() => AllParkingsView()),
    },
    {
      'title': 'Statistics',
      'icon': LucideIcons.barChart2,
      'color': Color(0xFFF5FCFF),
      'accentColor': Color(0xFF2B6CB0),
      'onTap': () => Get.to(() => ParkingStatsView()),
    },
    {
      'title': 'Reports',
      'icon': LucideIcons.fileText,
      'color': Color(0xFFFAF5FF),
      'accentColor': Color(0xFF553C9A),
      'onTap': () => Get.to(() => MonthlyParkingReportView()),
    },
    {
      'title': 'Connect Printer',
      'icon': LucideIcons.printer,
      'color': Color(0xFFFFF5F7),
      'accentColor': Color(0xFF97266D),
      'onTap': () => Get.to(() => PrintersAvailableView()),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      appBar: NeumorphicAppBar(
        title: Text(
            'Parking Manager',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              letterSpacing: 0.5,
              color: Color(0xFF1A202C),
            )
        ),
        centerTitle: true,
        color: Color(0xFFF8FAFC),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 24),
            // Logo and app name section with subtle animation
            Center(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      LucideIcons.car,
                      size: 48,
                      color: Color(0xFF2D3748),
                    ),
                  ).animate()
                      .fadeIn(duration: 800.ms, curve: Curves.easeOut),
                  SizedBox(height: 12),
                ],
              ),
            ),
            // Feature grid with refined styling and fixed overflow
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0, // Adjusted ratio to prevent overflow
                  ),
                  itemCount: featureTiles.length,
                  itemBuilder: (context, index) {
                    return _buildFeatureTile(
                      context: context,
                      title: featureTiles[index]['title'],
                      icon: featureTiles[index]['icon'],
                      color: featureTiles[index]['color'],
                      accentColor: featureTiles[index]['accentColor'],
                      onTap: featureTiles[index]['onTap'],
                      index: index,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Color accentColor,
    required VoidCallback onTap,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: accentColor.withOpacity(0.08),
            highlightColor: accentColor.withOpacity(0.04),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 26,
                      color: accentColor,
                    ),
                  ).animate()
                      .fadeIn(duration: 1000.ms, delay: 150.ms * index),
                  SizedBox(height: 12), // Reduced vertical spacing
                  // Wrapped in Flexible to handle overflow
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2, // Allow two lines for longer text
                      overflow: TextOverflow.ellipsis, // Handle any remaining overflow
                      style: TextStyle(
                        fontSize: 14, // Slightly smaller font
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: 100.ms * index, duration: 800.ms)
        .slideY(begin: 0.05, end: 0, delay: 100.ms * index, duration: 800.ms, curve: Curves.easeOutQuint);
  }
}