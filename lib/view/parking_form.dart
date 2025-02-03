import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:parkingapp/view/qr_display.dart';
import '../view_model/parking_viewmodel.dart';

class ParkingFormView extends StatelessWidget {
  final ParkingViewModel vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Parking')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _buildTextField(
              'Vehicle Number',
                  (v) => vm.currentParking.value.vehicleNumber = v,
            ),
            _buildTextField(
              'Owner Name',
                  (v) => vm.currentParking.value.ownerName = v,
            ),
            _buildTextField(
              'Phone Number',
                  (v) => vm.currentParking.value.phoneNumber = v,
            ),
            _buildTextField(
              'ID Card Number',
                  (v) => vm.currentParking.value.idCardNumber = v,
            ),
            Obx(
                  () => vm.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: () async {
                  await vm.createNewParking();
                  Get.to(() => QrDisplayView());
                },
                child: Text('GENERATE QR'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Define the _buildTextField helper method
  Widget _buildTextField(String label, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: label,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
