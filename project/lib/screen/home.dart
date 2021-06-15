import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

import 'view_page.dart';

class Page {
  final String content;
  final String id;
  late final Future<String> image;
  final String title;

  Page(this.content, this.id, this.title) {
    image = Get.find<FirebaseStorage>().ref('/page/$id').getDownloadURL();
  }

  factory Page.fromDoc(DocumentSnapshot snap) =>
      Page(snap.get('content'), snap.id, snap.get('title'));

  Widget toWidget() {
    return Card(
        child: InkWell(
            splashColor: Colors.amber.withAlpha(30),
            onTap: () => Get.to(() => PageViewerScreen(title, id)),
            child: Column(children: [
              FutureBuilder<String>(
                  future: image,
                  builder: (ctx, snap) => snap.hasError
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 50),
                          child: Text('Error loading'
                              ' page banner'),
                        )
                      : (snap.hasData
                          ? Image.network(snap.data!)
                          : Text('loading...'))),
              Container(
                  margin: EdgeInsets.all(20),
                  child: Center(
                      child: Text(title.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))))
            ])));
  }
}

class HomeScreenController extends GetxController {
  RxList<Page> pages = <Page>[].obs;

  late final sub;

  @override
  void onInit() {
    super.onInit();

    sub = Get.find<FirebaseFirestore>()
        .collection('pages')
        .withConverter(
            fromFirestore: (snap, opts) => Page.fromDoc(snap),
            toFirestore: (Page p, opts) => {})
        .snapshots()
        .listen((snap) {
      pages.clear();
      snap.docs.forEach((element) => pages.add(element.data()));
    });
  }

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }
}

class HomeScreen extends Screen<HomeScreenController> {
  HomeScreen() : super("Home", "home", true) {
    pageController = HomeScreenController();
  }

  final FirebaseAuth auth = Get.put(FirebaseAuth.instance);
  final FirebaseFirestore firestore = Get.put(FirebaseFirestore.instance);
  final FirebaseStorage storage = Get.put(FirebaseStorage.instance);

  @override
  Widget body(HomeScreenController controller) {
    return Container(
        child: Center(
            child: ListView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int index) =>
          controller.pages[index].toWidget(),
      itemCount: controller.pages.length,
    )));
  }
}
