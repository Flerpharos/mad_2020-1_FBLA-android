import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

import 'user_display.dart';

class PageViewerController extends GetxController {}

class PageViewerScreen extends Screen<PageViewerController> {
  late final Future<String> source;
  final String id;

  PageViewerScreen(String title, String this.id)
      : super(title, 'home', false, false) {
    pageController = PageViewerController();
    source = Get.find<FirebaseFirestore>()
        .collection('pages')
        .doc(id)
        .withConverter(
            fromFirestore:
                (DocumentSnapshot<Map<String, dynamic>> snap, opts) =>
                    snap.get('content') as String,
            toFirestore: (String source, opts) =>
                <String, Object?>{'content': source})
        .get()
        .then((value) => value.data()!);
  }

  @override
  AppBar topBar(String title) {
    return AppBar(title: Text(title), actions: [
      IconButton(
          icon: Icon(Icons.account_circle),
          onPressed: () => Get.to(() => UserDisplayScreen(id: id)))
    ]);
  }

  @override
  Widget body(PageViewerController controller) {
    return FutureBuilder<String>(
        future: source,
        builder: (ctx, state) => Container(
            child: state.hasData ? Markdown(data: state.data!) : null));
  }
}
