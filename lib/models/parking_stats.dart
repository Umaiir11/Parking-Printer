class ParkingStatsModel {
  int totalSlots;
  int totalIn;
  int totalOut;

  ParkingStatsModel({required this.totalSlots, required this.totalIn, required this.totalOut});

  factory ParkingStatsModel.fromJson(Map<String, dynamic> json) {
    return ParkingStatsModel(
      totalSlots: json['totalSlots'] ?? 0,
      totalIn: json['totalIn'] ?? 0,
      totalOut: json['totalOut'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalSlots': totalSlots,
      'totalIn': totalIn,
      'totalOut': totalOut,
    };
  }
}
