import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<_AppController>(
            init: _AppController(),
            builder: (value) {
              if (value.err)
                return Container(
                    child: Center(
                        child: Text("An error has occured",
                            style: TextStyle(color: "red".toColor()))));

              if (value.done) {
                FirebaseAuth.instance.authStateChanges().listen((u) => u == null
                    ? Get.offAllNamed('/picker')
                    : Get.offAllNamed('/home'));
              }

              return _SplashScreen();
            }));
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<_SplashScreenController>(
        init: _SplashScreenController(),
        builder: (value) {
          return Container(
              color: Get.isPlatformDarkMode
                  ? '#121212'.toColor()
                  : '#4c73c7'.toColor());
        });
  }
}

class _AppController extends GetxController {
  bool _complete = false;
  bool _err = false;

  bool get err => _err;
  bool get done => _complete;

  @override
  void onReady() {
    Firebase.initializeApp()
        .then((val) => _complete = true)
        .onError((_, __) => _err = true)
        .whenComplete(() => update());
    super.onReady();
  }
}

class _SplashScreenController extends GetxController {
  int _value = 0;
  bool _running = true;

  double get value {
    double temp = _value / 720;
    return pow(temp, 5) / (pow(temp, 5) + pow(1 - temp, 5));
  }

  @override
  void onReady() {
    Future.doWhile(() async {
      _value = (_value + 1) % 720;
      update();
      await Future.delayed(const Duration(milliseconds: 1));
      return _running;
    });
    super.onReady();
  }

  @override
  void onClose() {
    _running = false;
    super.onClose();
  }
}
