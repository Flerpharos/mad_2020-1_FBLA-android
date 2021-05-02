import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth auth = Get.put(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title'), actions: [
        IconButton(
            icon: Icon(Icons.logout),
            iconSize: 24,
            onPressed: () => auth.signOut())
      ]),
      body: Container(
          child: Center(child: Text("Hello, ${auth.currentUser!.email}"))),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.house), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Menu")
      ], currentIndex: 0),
    );
  }
}
