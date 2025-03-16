class ParkingModel {
  String? id;
  String? vehicleNumber;
  String? ownerName;
  String? phoneNumber;
  String? idCardNumber;
  DateTime? entryTime;
  DateTime? exitTime;
  String? qrCode;
  double? totalAmount;
  bool? isActive;
  String? parkingDuration;
  double? amountPerHour; // New field for the per-hour parking rate


  ParkingModel({
    this.amountPerHour,
    this.id,
    this.vehicleNumber,
    this.ownerName,
    this.phoneNumber,
    this.idCardNumber,
    this.entryTime,
    this.exitTime,
    this.qrCode,
    this.totalAmount,
    this.isActive,
    this.parkingDuration,  // Add parkingDuration to the constructor
  });

  // Convert a ParkingModel object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleNumber': vehicleNumber,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'idCardNumber': idCardNumber,
      'entryTime': entryTime,
      'exitTime': exitTime,
      'qrCode': qrCode,
      'totalAmount': totalAmount,
      'isActive': isActive,
      'parkingDuration': parkingDuration,  // Add parkingDuration to the map
      'amountPerHour': amountPerHour,  // Add parkingDuration to the map
    };
  }

  // Create a ParkingModel object from a Map
  factory ParkingModel.fromMap(Map<String, dynamic> map) {
    return ParkingModel(
      id: map['id'],
      vehicleNumber: map['vehicleNumber'],
      ownerName: map['ownerName'],
      phoneNumber: map['phoneNumber'],
      idCardNumber: map['idCardNumber'],
      entryTime: map['entryTime']?.toDate(),
      exitTime: map['exitTime']?.toDate(),
      qrCode: map['qrCode'],
      totalAmount: map['totalAmount'],
      isActive: map['isActive'],
      amountPerHour: map['amountPerHour'],
      parkingDuration: map['parkingDuration'],  // Read parkingDuration from the map
    );
  }

  // Method to calculate parking duration and update the parkingDuration field
  String calculateDuration() {
    if (entryTime == null || exitTime == null) {
      return 'Duration unavailable';
    }

    final duration = exitTime!.difference(entryTime!);
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    // Format the duration as "X hours Y minutes Z days"
    return '$hours hour${hours != 1 ? 's' : ''} $minutes minute${minutes != 1 ? 's' : ''} ${days > 0 ? '$days day${days > 1 ? 's' : ''}' : ''}'.trim();
  }
}
