import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'models/parking_model.dart';

class ParkingRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createParking(ParkingModel parking) async {
    parking.entryTime = DateTime.now();
    parking.isActive = true;
    final docRef = _firestore.collection('parkings').doc();
    await docRef.set(parking.toMap());
    return docRef.id;
  }

  Future<ParkingModel?> getParking(String qrCode) async {
    final doc = await _firestore.collection('parkings').doc(qrCode).get();
    return doc.exists ? ParkingModel.fromMap(doc.data()!) : null;
  }

  Future<void> completeParking(String qrCode) async {
    final doc = await _firestore.collection('parkings').doc(qrCode).get();
    if (!doc.exists) return;

    final parking = ParkingModel.fromMap(doc.data()!);
    final exitTime = DateTime.now();

    await _firestore.collection('parkings').doc(qrCode).update({
      'exitTime': exitTime,
      'isActive': false,
      'totalAmount': _calculateTotal(parking.entryTime!, exitTime),
    });
  }

  double _calculateTotal(DateTime entryTime, DateTime exitTime) {
    final duration = exitTime.difference(entryTime).inHours;
    return duration * 100.0; // Rs. 100 per hour
  }
}
