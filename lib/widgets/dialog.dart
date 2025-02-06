import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';


void showQRExpiredDialog() {
  Get.bottomSheet(
    Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.grey[300], // Light Neumorphic background
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)), // More rounded top
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                offset: Offset(2, 2),
                blurRadius: 6,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-2, -2),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 12),
              Neumorphic(
                style: NeumorphicStyle(
                  depth: 2,
                  intensity: 0.6,
                  color: Colors.grey[300],
                  boxShape: NeumorphicBoxShape.circle(),
                ),
                padding: EdgeInsets.all(12),
                child: Icon(Icons.local_parking, color: Colors.red.shade700, size: 28),
              ),
              SizedBox(height: 12),
              Text(
                "QR Expired",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                  "QR code expired.\n Please generate a new one.", textAlign: TextAlign.center,               style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: NeumorphicButton(
                  onPressed: () => Get.back(),
                  style: NeumorphicStyle(
                    depth: 2,
                    intensity: 0.8,
                    color: Colors.grey[300],
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "Dismiss",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    isDismissible: true,
    enableDrag: true,
  );
}

