import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

import 'user_display.dart';

class UserListController extends GetxController {
  final FirebaseFirestore firestore = Get.find<FirebaseFirestore>();
  late final CollectionReference profiles;
  final List<DocumentSnapshot> users = [];
  DocumentSnapshot? newest;
  var limit = 0.obs;

  @override
  void onInit() {
    profiles = firestore.collection('profiles');
    profiles.limit(10).get().then((snap) {
      snap.docs.forEach((item) {
        if (item.exists &&
            item.id != Get.find<FirebaseAuth>().currentUser!.uid) {
          users.add(item);
          limit++;
        }
      });
      newest = users.last;
    });

    super.onInit();
  }

  DocumentSnapshot? getUser(int index) {
    if (users.length - index < 5)
      (newest != null ? profiles.startAfterDocument(newest!) : profiles)
          .limit(10)
          .where('')
          .get()
          .then((snap) {
        snap.docs.forEach((item) {
          if (item.exists &&
              item.id != Get.find<FirebaseAuth>().currentUser!.uid) {
            users.add(item);
            limit++;
          }
        });
        newest = users.last;
      });

    return users[index];
  }
}

class UserListScreen extends Screen<UserListController> {
  UserListScreen() : super('People', 'users', true) {
    pageController = UserListController();
  }

  @override
  Widget body(UserListController controller) {
    return Container(
        child: ListView.builder(
            itemBuilder: (ctx, index) {
              final user = controller.getUser(index)!;
              final String photoURL = user.get('photo');

              return ListTile(
                leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: (photoURL != ''
                            ? NetworkImage(photoURL)
                            : AssetImage('assets/degrees.png'))
                        as ImageProvider<Object>),
                subtitle: Text(user.get('email') as String),
                title: Text(user.get('name') as String),
                trailing: Icon(Icons.arrow_forward),
                onLongPress: () => Get.to(() => UserDisplayScreen(id: user.id)),
              );
            },
            itemCount: controller.limit.value));
  }
}
