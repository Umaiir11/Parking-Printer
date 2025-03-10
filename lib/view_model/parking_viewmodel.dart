import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:parkingapp/global_variables.dart';
import 'package:uuid/uuid.dart';
import '../models/parking_model.dart';
import '../models/parking_stats.dart';
import '../repo/parking_repo.dart';
import '../repo/parking_stats_repo.dart';

class ParkingViewModel extends GetxController {
  final RxList<Map<String, dynamic>> monthlyReports = <Map<String, dynamic>>[].obs;

  final ParkingRepository _parkingRepo = ParkingRepository();
  final ParkingStatsRepository _repo = ParkingStatsRepository();
  final Rx<ParkingModel> currentParking = ParkingModel().obs;
   RxString  perHourPRate =''.obs;
  final RxString qrData = ''.obs;
  final RxBool isLoading = false.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxString parkingDuration = ''.obs;  // New variable for displaying hours, minutes, and days
  final RxInt totalSlots = 0.obs;
  final RxInt totalIn = 0.obs;
  final RxInt totalOut = 0.obs;

  final RxBool isFetching = false.obs;
  final RxBool isReportLoading = false.obs;
  var monthsList = <String>[
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ].obs;
  var selectedMonth = ''.obs;
  var reportData = <String, dynamic>{}.obs;

  Future<void> fetchMonthlyData(String month) async {
    isReportLoading.value = true;
    selectedMonth.value = month;
    reportData.value = await _parkingRepo.fetchMonthlyData(month);
    isReportLoading.value = false;
  }



  Future<void> fetchParkingStats() async {
    isFetching.value = true;
    try {
      final stats = await _repo.getParkingStats();

      totalSlots.value = stats.totalSlots ?? 22;
      totalIn.value = stats.totalIn ?? 0;
      totalOut.value = stats.totalOut ?? 0;
    } catch (e) {
      print("Error fetching parking stats: $e");
    } finally {
      isFetching.value = false;
    }
  }

  static const double perHourRate = 5.0;



  // Future<bool> createNewParking() async {
  //   isLoading.value = true;
  //   try {
  //     final stats = await _repo.getParkingStats();
  //
  //     if (stats.totalSlots == null || stats.totalSlots <= 0) {
  //       return false; // Return false if total slots are null or zero
  //     }
  //
  //     currentParking.value.entryTime = DateTime.now();
  //     final id = await _parkingRepo.createParking(currentParking.value);
  //     qrData.value = id;
  //
  //     // Update stats (reduce available slots, increase total in)
  //     await _repo.updateParkingStats(
  //       totalSlots: stats.totalSlots - 1,
  //       totalIn: stats.totalIn + 1,
  //     );
  //
  //     return true; // Return true when parking is created successfully
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  Future<bool> createNewParking() async {
    isLoading.value = true;
    try {
      final stats = await _repo.getParkingStats();

      if (stats.totalSlots == null || stats.totalSlots <= 0) {
        return false; // Return false if total slots are null or zero
      }

      // Generate Unique ID
      final String parkingId = const Uuid().v4();

      // Set entry time
      currentParking.value.entryTime = DateTime.now();

      // Generate QR Code using the unique parking ID
      final String qrCode = "QR_$parkingId";
      qrData.value = qrCode;

      double rate = (perHourPRate.value.isEmpty) ? 5.0 : double.tryParse(perHourPRate.value) ?? 5.0;
      GlobalVariables.gbRatePerHour = rate;
      currentParking.value.id = parkingId;
      currentParking.value.qrCode = qrCode;
      currentParking.value.totalAmount = rate;
      totalAmount.value =rate;
      final storedId = await _parkingRepo.createParking(currentParking.value);

      if (storedId == null) {
        return false;
      }

      // Update parking stats
      await _repo.updateParkingStats(
        totalSlots: stats.totalSlots - 1,
        totalIn: stats.totalIn + 1,
      );

      return true; // Parking successfully created
    } finally {
      isLoading.value = false;
    }
  }




  Future<bool> completeParking() async {
    isLoading.value = true;
    try {
      final parking = await _parkingRepo.getParking(qrData.value);
      if (parking == null || parking.isActive == false) return false;

      await _parkingRepo.completeParking(qrData.value);

      final updatedParking = await _parkingRepo.getParking(qrData.value);
      if (updatedParking != null) {
        updatedParking.exitTime = DateTime.now();
        currentParking.value = updatedParking;

        totalAmount.value = _calculateTotal(updatedParking.entryTime!, updatedParking.exitTime!);
        parkingDuration.value = _calculateDuration(updatedParking.entryTime!, updatedParking.exitTime!);

        // Update stats (increase available slots, increase total out)
        final stats = await _repo.getParkingStats();
        await _repo.updateParkingStats(
          totalSlots: stats.totalSlots + 1,
          totalOut: stats.totalOut + 1,
        );
      }
      return true;
    } finally {
      isLoading.value = false;
    }
  }




  // Future<void> createNewParking() async {
  //   isLoading.value = true;
  //   try {
  //     currentParking.value.entryTime = DateTime.now(); // Set start time
  //     final id = await _repo.createParking(currentParking.value);
  //     qrData.value = id;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  final RxBool isProcessing = false.obs; // Add this in ViewModel

  // Future<bool> completeParking() async {
  //   isLoading.value = true;
  //   try {
  //     final parking = await _repo.getParking(qrData.value);
  //     if (parking == null || parking.isActive == false) {
  //       return false; // If parking is inactive or doesn't exist, return false
  //     }
  //
  //     await _repo.completeParking(qrData.value);
  //
  //     final updatedParking = await _repo.getParking(qrData.value);
  //     if (updatedParking != null) {
  //       updatedParking.exitTime = DateTime.now(); // Set end time
  //       currentParking.value = updatedParking;
  //
  //       // Calculate total price
  //       totalAmount.value = _calculateTotal(updatedParking.entryTime!, updatedParking.exitTime!);
  //
  //       // Calculate and update parking duration in hours, minutes, and days
  //       parkingDuration.value = _calculateDuration(updatedParking.entryTime!, updatedParking.exitTime!);
  //     }
  //     return true;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


  double _calculateTotal(DateTime start, DateTime end) {
    final duration = end.difference(start).inHours;

    // Use perHourRate if perHourPRate is null or empty, otherwise convert perHourPRate to double
    double rate = (perHourPRate.value.isEmpty) ? perHourRate : double.tryParse(perHourPRate.value) ?? perHourRate;
GlobalVariables.gbRatePerHour =rate;
    return duration * rate;
  }


  String _calculateDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);

    final days = duration.inDays;
    final hours = duration.inHours % 24; // Get remaining hours after days
    final minutes = duration.inMinutes % 60; // Get remaining minutes after hours

    // Format the result based on days, hours, and minutes
    if (days > 0) {
      return '$hours hours $minutes minute${minutes > 1 ? 's' : ''} $days day${days > 1 ? 's' : ''}';
    } else {
      return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''} 0 day';
    }
  }
}
