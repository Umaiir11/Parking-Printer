import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/parking_stats.dart';

class ParkingStatsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateParkingStats({int? totalSlots, int? totalIn, int? totalOut}) async {
    final stats = await getParkingStats();
    final updatedStats = ParkingStatsModel(
      totalSlots: totalSlots ?? stats.totalSlots,
      totalIn: totalIn ?? stats.totalIn,
      totalOut: totalOut ?? stats.totalOut,
    );
    await _firestore.collection('parkingStats').doc('stats').set(updatedStats.toJson());
  }

  Future<ParkingStatsModel> getParkingStats() async {
    final snapshot = await _firestore.collection('parkingStats').doc('stats').get();
    if (snapshot.exists) {
      return ParkingStatsModel.fromJson(snapshot.data()!);
    }
    return ParkingStatsModel(totalSlots: 0, totalIn: 0, totalOut: 0);
  }
}
