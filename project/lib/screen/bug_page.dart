import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:project/util/screen.dart';

class Ticket {
  final String id;
  final String title;
  final String content;
  final int ticketState;

  const Ticket(this.id, this.title, this.content, this.ticketState);

  factory Ticket.fromDoc(DocumentSnapshot snap) {
    return Ticket(
        snap.id, snap.get('title'), snap.get('content'), snap.get('state'));
  }

  IconData _iconFromState() {
    switch (ticketState) {
      case 0:
        return Icons.query_builder;
      case 1:
        return Icons.assignment_ind;
      case 2:
        return Icons.done;
      default:
        return Icons.notes;
    }
  }

  String _textFromState() {
    switch (ticketState) {
      case 0:
        return 'Waiting';
      case 1:
        return 'Ticket Assigned';
      case 2:
        return 'Issue Solved';
      default:
        return 'Ticket Closed';
    }
  }

  Widget toWidget() {
    return ListTile(
        title: Text(title),
        subtitle: Text(id),
        leading: Icon(_iconFromState()),
        trailing: const Icon(Icons.arrow_forward),
        onLongPress: () {
          Get.dialog(SimpleDialog(
              title: Text(title, overflow: TextOverflow.fade),
              titlePadding: EdgeInsets.all(15),
              contentPadding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              children: [
                Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Row(children: [
                        Icon(_iconFromState()),
                        Text(_textFromState())
                      ]),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(
                        'Ticket $id',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Text(content),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      ElevatedButton(
                          onPressed: () {
                            Get.find<FirebaseFirestore>()
                                .collection('reports')
                                .doc(id)
                                .update({'state': 4});
                            Get.back();
                          },
                          child: Text('Close Ticket'))
                    ]))
              ]));
        });
  }
}

class ReportsController extends GetxController {
  final FirebaseFirestore firestore = Get.find<FirebaseFirestore>();
  late final CollectionReference reports;
  List<Ticket> reportsList = [];
  var limit = 0.obs;

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  late final StreamSubscription sub;

  @override
  void onInit() {
    reports = firestore.collection('reports');
    sub = reports
        .where('user', isEqualTo: Get.find<FirebaseAuth>().currentUser!.uid)
        .snapshots()
        .listen((snap) {
      reportsList = snap.docs.map<Ticket>((d) => Ticket.fromDoc(d)).toList();
      limit.value = reportsList.length;
    });

    super.onInit();
  }

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }

  void sendReport() async {
    if (formKey.currentState!.saveAndValidate()) {
      await reports.add({
        'title': formKey.currentState!.value['title'],
        'content': formKey.currentState!.value['content'],
        'user': Get.find<FirebaseAuth>().currentUser!.uid,
        'state': 0
      });
      Get.back();
    }
  }
}

class ReportsScreen extends Screen<ReportsController> {
  ReportsScreen() : super('Tickets', 'home', true, true, true) {
    pageController = ReportsController();
  }

  @override
  Widget getFAB() {
    return FloatingActionButton(
      onPressed: () => Get.dialog(SimpleDialog(
          title: Text('Create Ticket'),
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
                    name: 'title',
                    decoration: InputDecoration(
                        labelText: "Subject",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ))),
                    validator: FormBuilderValidators.required(Get.context!),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  FormBuilderTextField(
                    name: 'content',
                    maxLines: 5,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Content',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.grey))),
                    validator: FormBuilderValidators.required(Get.context!),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  ElevatedButton(
                      onPressed: pageController.sendReport,
                      child: Text('Create'))
                ]),
              ),
            )
          ])),
      child: Icon(Icons.note_add),
    );
  }

  @override
  Widget body(ReportsController controller) {
    return Container(
        child: ListView.builder(
      itemBuilder: (ctx, index) => controller.reportsList[index].toWidget(),
      itemCount: controller.limit.value,
    ));
  }
}
