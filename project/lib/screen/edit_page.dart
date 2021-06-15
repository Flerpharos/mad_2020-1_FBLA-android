import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/util/screen.dart';

class MyPageController extends GetxController {
  var isEditingText = false.obs;
  var fabExpanded = false.obs;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  late final StreamSubscription sub;

  final RxMap<String, String> map = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    sub = Get.find<FirebaseFirestore>()
        .collection('pages')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .withConverter(
            fromFirestore:
                (DocumentSnapshot<Map<String, dynamic>> snap, opts) =>
                    <String, String>{
                      'content': snap.get('content'),
                      'title': snap.get('title')
                    },
            toFirestore: (Map<String, String> source, opts) => source)
        .snapshots()
        .listen((value) => map.value = value.data()!);
  }

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }

  void editPageImage() async {
    ImagePicker picker = Get.find<ImagePicker>();

    final imageRef = FirebaseStorage.instance
        .ref('/page/${FirebaseAuth.instance.currentUser!.uid}');

    final data = File((await picker.getImage(
            source: ImageSource.gallery,
            maxWidth: 1024,
            maxHeight: 512,
            imageQuality: 20))!
        .path);
    try {
      await imageRef.putFile(data);
    } catch (err) {
      Get.bottomSheet(
          Container(
              height: 100,
              color: Colors.red.shade400,
              child: Center(
                child: Text(
                    'Error: Image too big to upload. Please use a '
                    'smaller file.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                    )),
              )),
          isDismissible: false);
      Future.delayed(Duration(seconds: 2), () => Get.back());
    }

    fabExpanded.value = false;
  }

  void editPage() async {
    final state = formKey.currentState!;

    if (state.saveAndValidate()) {
      await FirebaseFirestore.instance
          .collection('pages')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'title': state.value['title'],
        'content': state.value['content']
      });

      fabExpanded.value = false;
      isEditingText.value = false;
    }
  }
}

class MyPageScreen extends Screen<MyPageController> {
  late final Future<Map<String, String>> source;

  MyPageScreen() : super('My Page', 'home', true, true, true) {
    pageController = MyPageController();
  }

  @override
  Widget getFAB() {
    return GetX<MyPageController>(
        init: pageController,
        builder: (controller) {
          if (controller.fabExpanded.value)
            return FloatingActionButton.extended(
                heroTag: 'pageEditor',
                onPressed: () {},
                label: Row(children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => controller.fabExpanded.value = false),
                  IconButton(
                      icon: Icon(Icons.delete_forever),
                      onPressed: () {
                        controller.isEditingText.value = false;
                        controller.fabExpanded.value = false;
                      }),
                  IconButton(
                      icon: Icon(Icons.image),
                      onPressed: pageController.editPageImage),
                  IconButton(
                      icon: Icon(Icons.done),
                      onPressed: pageController.editPage)
                ]));
          if (controller.isEditingText.value)
            return FloatingActionButton(
                heroTag: 'pageEditor',
                onPressed: () => controller.fabExpanded.value = true,
                child: Icon(Icons.more_vert));
          return FloatingActionButton(
              heroTag: 'pageEditor',
              onPressed: () => controller.isEditingText.value = true,
              child: Icon(Icons.edit));
        });
  }

  @override
  Widget body(MyPageController controller) {
    controller.isEditingText.value;

    return Container(
        child: controller.isEditingText.value
            ? FormBuilder(
                key: controller.formKey,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    FormBuilderTextField(
                        initialValue: controller.map['title'] ?? '',
                        name: 'title',
                        decoration: InputDecoration(
                            labelText: "Title",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ))),
                        validator:
                            FormBuilderValidators.required(Get.context!)),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                        initialValue: controller.map['content'] ?? '',
                        name: 'content',
                        maxLines: 30,
                        decoration: InputDecoration(
                            labelText: "Content",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ))),
                        validator:
                            FormBuilderValidators.required(Get.context!)),
                  ]),
                ))
            : Markdown(data: controller.map['content'] ?? ''));
  }
}
