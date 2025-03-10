import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import '../models/parking_model.dart';

class ParkingRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createParking(ParkingModel parking) async {
    parking.entryTime = DateTime.now();
    parking.isActive = true;

    final docRef = _firestore.collection('parkings').doc();
    parking.id = docRef.id;

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

    // Calculate the total amount and parking duration
    final totalAmount = _calculateTotal(parking.entryTime!, exitTime);
    final parkingDuration = _calculateDuration(parking.entryTime!, exitTime);

    // Update the Firestore document with exit time, total amount, isActive status, and parking duration
    await _firestore.collection('parkings').doc(qrCode).update({
      'exitTime': exitTime,
      'isActive': false,
      'totalAmount': totalAmount,
      'parkingDuration': parkingDuration,
    });
  }
  Future<Map<String, dynamic>> fetchMonthlyData(String monthKey) async {
    final querySnapshot = await _firestore.collection('parkings').get();

    Map<String, dynamic> report = {
      'totalSlots': 0,
      'totalIn': 0,
      'totalOut': 0,
      'totalEarnings': 0.0,
      'dailyEarnings': <String, double>{},
    };

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final entryTime = (data['entryTime'] as Timestamp).toDate();
      final exitTime = data['exitTime'] != null ? (data['exitTime'] as Timestamp).toDate() : null;
      final totalAmount = (data['totalAmount'] ?? 0.0).toDouble();

      // Extract month name from entry time
      String docMonth = DateFormat('MMMM').format(entryTime);

      if (docMonth == monthKey) {
        report['totalSlots'] += 1;
        report['totalIn'] += 1;
        report['totalEarnings'] += totalAmount; // ✅ Always add earnings

        final day = entryTime.day.toString();
        report['dailyEarnings'][day] = (report['dailyEarnings'][day] ?? 0.0) + totalAmount;

        if (exitTime != null) {
          report['totalOut'] += 1;
        }
      }
    }
    return report;
  }
  double _calculateTotal(DateTime entryTime, DateTime exitTime) {
    final duration = exitTime.difference(entryTime).inHours;
    return duration * 100.0; // Rs. 100 per hour
  }

  String _calculateDuration(DateTime entryTime, DateTime exitTime) {
    final duration = exitTime.difference(entryTime);

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    // Format the duration as "X hours Y minutes Z days"
    return '$hours hour${hours != 1 ? 's' : ''} $minutes minute${minutes != 1 ? 's' : ''} ${days > 0 ? '$days day${days > 1 ? 's' : ''}' : ''}'.trim();
  }



}
