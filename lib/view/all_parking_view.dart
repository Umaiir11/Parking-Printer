import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../components/dialog.dart';
import '../view_model/parking_viewmodel.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AllParkingsView extends StatefulWidget {
  @override
  State<AllParkingsView> createState() => _AllParkingsViewState();
}

class _AllParkingsViewState extends State<AllParkingsView> {
  final ParkingViewModel vm = Get.find();
  final RxString searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    vm.loadAllParkings();
  }

  Future<void> _refreshData() async {
    await vm.loadAllParkings();
  }

  Widget _buildAnimatedTextField({
    required IconData icon,
    required String label,
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            labelStyle: TextStyle(
              color: NeumorphicTheme.defaultTextColor(Get.context!).withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            prefixIcon: Icon(icon, color: NeumorphicTheme.defaultTextColor(Get.context!)),
          ),
          onChanged: onChanged,
        ),
      ).animate()
          .fadeIn(duration: 500.ms, delay: 300.ms)
          .slide(begin: const Offset(30, 0), duration: 500.ms, curve: Curves.easeOutCubic)
          .scale(duration: 300.ms),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      appBar: NeumorphicAppBar(
        title: const Text(
          'All Parkings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAnimatedTextField(
              icon: LucideIcons.search,
              label: "Search by Vehicle Number",
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (vm.isFetchingAllParkings.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final filteredList = vm.parkingList
                    .where((parking) =>
                    (parking.vehicleNumber ?? "").toLowerCase().contains(searchQuery.value))
                    .toList();


                if (filteredList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(LucideIcons.parkingCircleOff, size: 48, color: Colors.grey.shade500),
                        const SizedBox(height: 8),
                        const Text(
                          "No Parkings Available",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final parking = filteredList[index];
                      final bool isActive = parking.isActive ?? false;
                      final Color tileColor = isActive ? Colors.blue.shade50 : Colors.red.shade50;
                      final String statusText = isActive ? "Active" : "Expired";
                      final Color statusColor = isActive ? Colors.green.shade500 : Colors.red.shade500;

                      String formatDate(DateTime? date) {
                        if (date == null) return "-";
                        return DateFormat("dd-MM-yy").format(date);
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: 1,
                            intensity: 0.8,
                            color: tileColor,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                            shadowDarkColor: Colors.black.withOpacity(0.1),
                            shadowLightColor: Colors.white.withOpacity(0.6),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              showQrDialog(context, parking.qrCode ?? "");
                            },
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              leading: Icon(
                                LucideIcons.car,
                                size: 24,
                                color: Colors.blueGrey.shade600,
                              ),
                              title: Text(
                                "Vehicle: ${parking.vehicleNumber}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Entry: ${formatDate(parking.entryTime)}",
                                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  if (parking.exitTime != null)
                                    Text(
                                      "Exit: ${formatDate(parking.exitTime)}",
                                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                                    ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  statusText,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ).animate().fade(duration: 300.ms).slideX(begin: -0.5, curve: Curves.easeOut),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
