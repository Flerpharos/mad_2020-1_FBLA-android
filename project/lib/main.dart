import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile.dart';
/*
import 'screen/app.dart';
import 'screen/home.dart';
import 'screen/login.dart';


void main() {
  runApp(GetMaterialApp(
      initialRoute: '/',
      defaultTransition: Transition.fade,
      routes: {
        '/': App().build,
        '/home': (ctx) => HomeScreen(),
        '/signin': (ctx) => LoginScreen(),
        '/signup': (ctx) => Placeholder(),
        /* Add More routes here */
      }));
}
*/

void main() {
  runApp(Home());
}