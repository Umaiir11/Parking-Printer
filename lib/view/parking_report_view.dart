import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../view_model/parking_viewmodel.dart';

class MonthlyParkingReportView extends StatefulWidget {
  @override
  State<MonthlyParkingReportView> createState() => _MonthlyParkingReportViewState();
}

class _MonthlyParkingReportViewState extends State<MonthlyParkingReportView> {
  final ParkingViewModel vm = Get.find();
  void initState() {
    // TODO: implement initState
    super.initState();

    if (vm.monthsList.isNotEmpty) {
      vm.selectedMonth.value = vm.monthsList.last;
      vm.fetchMonthlyData(vm.selectedMonth.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: Text(
          'Monthly Parking Report',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(() => _buildMonthDropdown()), // Dropdown for Month Selection
            SizedBox(height: 16),
            Obx(() {
              if (vm.isReportLoading.value) return Center(child: CupertinoActivityIndicator());
              if (vm.reportData.isEmpty) return Center(child: Text("No data available"));

              return Column(
                children: [
                  _buildSummaryChart(), // Graph of Daily Earnings
                  SizedBox(height: 20),
                  _buildSummaryCard(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthDropdown() {
    return Neumorphic(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      style: NeumorphicStyle(depth: -4, intensity: 0.8),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: vm.selectedMonth.value,
          items: vm.monthsList.map((month) {
            return DropdownMenuItem(
              value: month,
              child: Text(month), // No need to format
            );
          }).toList(),
          onChanged: (newMonth) {
            if (newMonth != null) vm.fetchMonthlyData(newMonth);
          },
        ),
      ),
    );
  }




  Widget _buildSummaryChart() {
    final report = vm.reportData;

    final sections = [
      PieChartSectionData(
        color: Colors.blueAccent,
        value: (report['totalSlots'] ?? 0).toDouble(),
        title: 'P',
        titleStyle: TextStyle(
          fontSize: 14, // Smaller but readable
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        radius: 55,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: (report['totalIn'] ?? 0).toDouble(),
        title: 'E',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.redAccent,
        value: (report['totalOut'] ?? 0).toDouble(),
        title: 'X',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        radius: 48,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: (report['totalEarnings'] ?? 0).toDouble(),
        title: 'AED',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        radius: 60,
      ),
    ];

    return Container(
      height: 320, // Slightly bigger for a premium look
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "Parking Overview",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: PieChart(
              PieChartData(
                sections: sections,
                borderData: FlBorderData(show: false),
                sectionsSpace: 3,
                centerSpaceRadius: 45, // More spacing for a clean look
              ),
            ),
          ),
          SizedBox(height: 8),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      children: [
        _buildLegendItem("Parkings", Colors.blueAccent),
        _buildLegendItem("Entries", Colors.green),
        _buildLegendItem("Exits", Colors.redAccent),
        _buildLegendItem("Earnings", Colors.orange),
      ],
    );
  }

  Widget _buildLegendItem(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(width: 12, height: 12, color: color),
        SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 14)),
      ],
    );
  }

    Widget _buildSummaryCard() {
      final report = vm.reportData;
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Column(
          children: [
            _buildDetailRow('Total Parkings', report['totalSlots'].toString()),
            _buildDetailRow('Total Entries', report['totalIn'].toString()),
            _buildDetailRow('Total Exits', report['totalOut'].toString()),
            _buildDetailRow('Total Earnings', "AED. ${report['totalEarnings'].toStringAsFixed(2)}"),
          ],
        ),
      );
    }

    Widget _buildDetailRow(String title, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          ],
        ),
      );
    }
}
