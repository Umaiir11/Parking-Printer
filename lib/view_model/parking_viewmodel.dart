import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/parking_model.dart';
import '../parking_repo.dart';

class ParkingViewModel extends GetxController {
  final ParkingRepository _repo = ParkingRepository();
  final Rx<ParkingModel> currentParking = ParkingModel().obs;
  final RxString qrData = ''.obs;
  final RxBool isLoading = false.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxString parkingDuration = ''.obs;  // New variable for displaying hours, minutes, and days

  static const double perHourRate = 50.0;

  Future<void> createNewParking() async {
    isLoading.value = true;
    try {
      currentParking.value.entryTime = DateTime.now(); // Set start time
      final id = await _repo.createParking(currentParking.value);
      qrData.value = id;
    } finally {
      isLoading.value = false;
    }
  }
  final RxBool isProcessing = false.obs; // Add this in ViewModel

  Future<bool> completeParking() async {
    isLoading.value = true;
    try {
      final parking = await _repo.getParking(qrData.value);
      if (parking == null || parking.isActive == false) {
        return false; // If parking is inactive or doesn't exist, return false
      }

      await _repo.completeParking(qrData.value);

      final updatedParking = await _repo.getParking(qrData.value);
      if (updatedParking != null) {
        updatedParking.exitTime = DateTime.now(); // Set end time
        currentParking.value = updatedParking;

        // Calculate total price
        totalAmount.value = _calculateTotal(updatedParking.entryTime!, updatedParking.exitTime!);

        // Calculate and update parking duration in hours, minutes, and days
        parkingDuration.value = _calculateDuration(updatedParking.entryTime!, updatedParking.exitTime!);
      }
      return true;
    } finally {
      isLoading.value = false;
    }
  }


  double _calculateTotal(DateTime start, DateTime end) {
    final duration = end.difference(start).inHours;
    return duration * perHourRate;
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
