import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skg_refactoring/app/ui/controllers/gps_controller.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = GPSController.instance;
    return GetBuilder<GPSController>(
      init: GPSController(),
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
              child: controller.isLoading
                  ? Container(
                      color: Colors.white,
                      height: double.infinity,
                      width: double.infinity,
                      child:
                          Center(child: Text("${controller.initialPosition}")),
                    )
                  : const Center(child: CircularProgressIndicator())),
        );
      },
    );
  }
}
