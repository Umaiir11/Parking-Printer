import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkingapp/view/parking_form.dart';
import 'package:parkingapp/view/scan_view.dart';

import '../view_model/parking_viewmodel.dart';

class HomeView extends StatelessWidget {
  final ParkingViewModel vm = Get.put(ParkingViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Manager'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => ParkingFormView()),
              child: Text('NEW PARKING'),
              style: _elevatedButtonStyle(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => ScanView()),
              child: Text('SCAN QR'),
              style: _elevatedButtonStyle(),
            ),
          ],
        ),
      ),
    );
  }

  /// Define a button style method
  ButtonStyle _elevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
