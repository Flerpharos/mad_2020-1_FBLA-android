import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/controller/app.dart';
import 'package:project/screen/splash.dart';
import 'package:supercharged/supercharged.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<AppController>(
            init: AppController(),
            builder: (value) {
              if (value.err)
                return Container(
                    child: Center(
                        child: Text("An error has occured",
                            style: TextStyle(color: "red".toColor()))));
              if (value.done) {
                FirebaseAuth.instance.authStateChanges().listen((u) => u == null
                    ? Get.offNamed('/signin')
                    : Get.offNamed('/home'));
              }

              return SplashScreen();
            }));
  }
}
