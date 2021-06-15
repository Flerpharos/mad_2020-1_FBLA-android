import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

class UserDisplayController extends GetxController {
  final firestore = Get.find<FirebaseFirestore>();
  late final Future<DocumentSnapshot> user;
  late final DocumentReference currentUser;

  RxBool hasRelation = false.obs;

  final String id;

  UserDisplayController(this.id) {
    user = firestore.collection('profiles').doc(id).get();
    currentUser = firestore
        .collection('users')
        .doc(Get.find<FirebaseAuth>().currentUser!.uid);

    currentUser.get().then((snap) {
      hasRelation.value = snap.get('relations')[id];
    });
  }

  void editRelation() async {
    final data = (await currentUser.get()).get('relations')!;

    await currentUser.update({'relations': data..[id] = !(data[id] ?? false)});

    hasRelation.value = data[id];
  }
}

class UserDisplayScreen extends Screen<UserDisplayController> {
  late final String id;

  UserDisplayScreen({required this.id})
      : super('', 'users', false, false, true, id) {
    pageController = Get.put(UserDisplayController(id), tag: id);
  }

  @override
  Widget getFAB() {
    return FloatingActionButton(
      onPressed: pageController.editRelation,
      child: GetX<UserDisplayController>(
          init: pageController,
          tag: id,
          builder: (UserDisplayController controller) => Icon(
              controller.hasRelation.value
                  ? Icons.bookmark_remove
                  : Icons.bookmark_add)),
    );
  }

  @override
  Widget body(UserDisplayController controller) {
    return FutureBuilder(
        future: controller.user,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return Container();
          } else {
            final user = snap.data as DocumentSnapshot;

            final String photoURL = user.get('photo');

            return Container(
                child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              children: [
                Center(
                  child: CircleAvatar(
                      radius: 60,
                      backgroundImage: (photoURL != ''
                              ? NetworkImage(photoURL)
                              : AssetImage('assets/degrees.png'))
                          as ImageProvider<Object>),
                ),
                Center(
                    child:
                        Text(user.get('name'), style: TextStyle(fontSize: 24))),
                Center(
                    child: Text(user.get('email'),
                        style: TextStyle(fontSize: 16))),
                const SizedBox(height: 20),
                Text('Gender', style: TextStyle(fontSize: 18)),
                Text(user.get('gender')),
                const SizedBox(height: 20),
                Text('Age', style: TextStyle(fontSize: 18)),
                Text(user.get('age').toString()),
                const SizedBox(height: 20),
                Text('Phone #', style: TextStyle(fontSize: 18)),
                Text(user.get('telephone')),
                const SizedBox(height: 20),
                Text('About', style: TextStyle(fontSize: 18)),
                Text(user.get('desc')),
              ],
            ));
          }
        });
  }
}
