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

  ParkingModel({
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
    );
  }
}