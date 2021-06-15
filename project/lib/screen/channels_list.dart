import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

import 'channel_display.dart';

class ChannelsListController extends GetxController {
  final FirebaseFirestore firestore = Get.find<FirebaseFirestore>();
  late final CollectionReference channels;
  List<DocumentSnapshot> channelList = [];
  var limit = 0.obs;

  final uid = Get.find<FirebaseAuth>().currentUser!.uid;
  final formKey = GlobalKey<FormBuilderState>();

  @override
  void onInit() {
    channels = firestore.collection('groups');
    sub = channels.snapshots().listen((snap) {
      channelList = snap.docs;
      limit.value = channelList.length;
    });

    super.onInit();
  }

  late final sub;

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }

  void createChannel() async {
    if (!formKey.currentState!.saveAndValidate()) return;

    final ref = await channels.add({
      'name': formKey.currentState!.value['name'],
      'members': {'$uid': 3}
    });

    await ref.collection('messages').doc('_default_').set({
      'message': '',
      'timestamp': Timestamp(0, 0),
      'user': firestore.collection('profiles').doc('admin')
    });

    Get.back();
    Get.to(() => ChannelDisplayScreen(id: ref.id));
  }
}

class ChannelsListScreen extends Screen<ChannelsListController> {
  ChannelsListScreen() : super('Messages', 'messages', true, true, true) {
    pageController = ChannelsListController();
  }

  @override
  Widget getFAB() {
    return FloatingActionButton(
      onPressed: () => Get.dialog(SimpleDialog(
          title: Text('Create New Channel'),
          titlePadding: EdgeInsets.all(15),
          contentPadding: EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: [
            Container(
              width: screen.width * 0.8,
              child: FormBuilder(
                key: pageController.formKey,
                child: Column(children: [
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ))),
                    validator: FormBuilderValidators.required(Get.context!),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  ElevatedButton(
                      onPressed: pageController.createChannel,
                      child: Text('Create'))
                ]),
              ),
            )
          ])),
      child: Icon(Icons.note_add),
    );
  }

  @override
  Widget body(ChannelsListController controller) {
    return Container(
        child: ListView.builder(
            itemBuilder: (ctx, index) {
              final channel = controller.channelList[index];

              return ListTile(
                  title: Text(channel.get('name') as String),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () =>
                      Get.to(() => ChannelDisplayScreen(id: channel.id)));
            },
            itemCount: controller.limit.value));
  }
}
