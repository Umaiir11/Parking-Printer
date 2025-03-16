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
  Future<List<ParkingModel>> fetchAllParkings() async {
    try {
      final querySnapshot = await _firestore.collection('parkings').get();
      return querySnapshot.docs.map((doc) => ParkingModel.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching parkings: $e");
      return [];
    }
  }

  Future<ParkingModel?> getParking(String qrCode) async {
    final querySnapshot = await _firestore
        .collection('parkings')
        .where('qrCode', isEqualTo: qrCode)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final doc = querySnapshot.docs.first;
      return ParkingModel.fromMap(doc.data());
    } else {
      return null;
    }
  }


  Future<void> completeParking(String qrCode) async {
    final querySnapshot = await _firestore
        .collection('parkings')
        .where('qrCode', isEqualTo: qrCode)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return;

    final doc = querySnapshot.docs.first;
    final parking = ParkingModel.fromMap(doc.data());
    final exitTime = DateTime.now();

    // Use model’s per-hour rate dynamically
    final totalAmount = _calculateTotal(parking.entryTime!, exitTime, parking.totalAmount?? 0);
    final parkingDuration = _calculateDuration(parking.entryTime!, exitTime);

    await doc.reference.update({
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
      final isActive = data['isActive'] ?? true;

      String docMonth = DateFormat('MMMM').format(entryTime);

      if (docMonth == monthKey) {
        report['totalSlots'] += 1;
        report['totalIn'] += 1;
        report['totalEarnings'] += totalAmount;

        final day = entryTime.day.toString();
        report['dailyEarnings'][day] = (report['dailyEarnings'][day] ?? 0.0) + totalAmount;

        if (exitTime != null && isActive == false) {
          report['totalOut'] += 1;
        }
      }
    }

    return report;
  }
  double _calculateTotal(DateTime entryTime, DateTime exitTime, double amountPerHour) {
    final totalMinutes = exitTime.difference(entryTime).inMinutes;

    if (totalMinutes <= 0) return amountPerHour; // Fallback for invalid case

    if (totalMinutes <= 60) {
      return amountPerHour; // Charge full 1st hour only
    } else {
      int extraMinutes = totalMinutes - 60;
      double perMinuteRate = amountPerHour / 60;
      double extraCharge = extraMinutes * perMinuteRate;
      double total = amountPerHour + extraCharge;
      return total; // No rounding
    }
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
