import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/splash.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
        init: SplashScreenController(),
        builder: (value) {
          return Container(
              child:
                  Center(child: CircularProgressIndicator(value: value.value)));
        });
  }
}
