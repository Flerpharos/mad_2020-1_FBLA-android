import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

import 'user_display.dart';

class BasicUserInfo {
  final String key;
  final String name;
  final String email;
  final String photoURL;

  const BasicUserInfo(this.key, this.name, this.email, this.photoURL);

  Widget toWidget() {
    return ListTile(
      leading: CircleAvatar(
          radius: 30,
          backgroundImage: (photoURL != ''
              ? NetworkImage(photoURL)
              : AssetImage('assets/degrees.png')) as ImageProvider<Object>),
      subtitle: Text(email),
      title: Text(name),
      trailing: Icon(Icons.arrow_forward),
      onLongPress: () => Get.to(() => UserDisplayScreen(id: key)),
    );
  }
}

class BookmarksController extends GetxController {
  final FirebaseFirestore firestore = Get.find<FirebaseFirestore>();
  final RxList<DocumentSnapshot> users = RxList<DocumentSnapshot>();

  Iterable<BasicUserInfo> getUsers() sync* {
    for (var user in users)
      yield BasicUserInfo(
          user.id, user.get('name'), user.get('email'), user.get('photo'));
  }

  late final sub;

  @override
  void onInit() {
    sub = firestore
        .collection('users')
        .doc(Get.find<FirebaseAuth>().currentUser!.uid)
        .snapshots()
        .listen((snap) {
      var temp = (snap.get('relations') as Map<String, dynamic>)
          .entries
          .where((e) => e.value)
          .map((e) => e.key);

      users.clear();
      temp.forEach((key) => firestore
          .collection('profiles')
          .doc(key)
          .get()
          .then((snap) => users.add(snap)));
    });

    super.onInit();
  }

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }
}

class BookmarksScreen extends Screen<BookmarksController> {
  BookmarksScreen() : super('Bookmarks', 'home', true) {
    pageController = BookmarksController();
  }

  @override
  Widget body(BookmarksController controller) {
    var temp = controller.users;

    return Container(
        child: ListView(children: [
      ...[...controller.getUsers()].map((i) => i.toWidget())
    ]));
  }
}
