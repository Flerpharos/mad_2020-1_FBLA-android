import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final FirebaseAuth auth = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Title')),
        body: Container(
            child: Center(child: Text("Hello, ${auth.currentUser!.email}"))));
  }
}
