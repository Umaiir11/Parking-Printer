import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../models/parking_model.dart';
import '../parking_repo.dart';

class ParkingViewModel extends GetxController {
  final ParkingRepository _repo = ParkingRepository();
  final Rx<ParkingModel> currentParking = ParkingModel().obs;
  final RxString qrData = ''.obs;
  final RxBool isLoading = false.obs;

  Future<void> createNewParking() async {
    isLoading.value = true;
    try {
      final id = await _repo.createParking(currentParking.value);
      qrData.value = id;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeParking() async {
    isLoading.value = true;
    try {
      await _repo.completeParking(qrData.value);
      currentParking.value = (await _repo.getParking(qrData.value))!;
    } finally {
      isLoading.value = false;
    }
  }
}