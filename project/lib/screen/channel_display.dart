import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:project/util/screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Message {
  final String message;
  final Timestamp timestamp;
  final DocumentReference user;
  final String id;

  late final Future<String> name;

  static const TextStyle title =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);

  static const TextStyle date = TextStyle(fontWeight: FontWeight.w300);

  Message(this.message, this.timestamp, this.user, this.id) {
    name = user.get().then<String>((snap) => snap.get('name') as String);
  }

  factory Message.fromSnapshot(DocumentSnapshot snap) => Message(
      snap.get('message')!, snap.get('timestamp')!, snap.get('user')!, snap.id);

  DateFormat getDateFormatter(DateTime time) {
    var diff = DateTime.now().difference(time);

    if (diff.inDays == 0)
      return DateFormat.jm();
    else if (DateTime.now().year != time.year)
      return DateFormat.yMMMd();
    else
      return DateFormat.MMMd();
  }

  /*Widget toWidget(DocumentReference? previousSender) {
    if ()
  }*/
  Widget toWidget() {
    return FutureBuilder(
        future: name,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
            GestureDetector(
              onTap: () => openEditSheet(snapshot.data as String?),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    if (snapshot.connectionState == ConnectionState.done)
                      Text(snapshot.data as String, style: title)
                    else
                      const Text('loading...', style: title),
                    Spacer(flex: 1),
                    Text(
                        getDateFormatter(timestamp.toDate())
                            .format(timestamp.toDate()),
                        style: date),
                    Spacer(flex: 20)
                  ]),
                  Text(message)
                ],
              ),
            ));
  }

  Widget toConsecutiveWidget() => FutureBuilder(
      future: name,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
          GestureDetector(
              onTap: () => openEditSheet(snapshot.data as String?),
              child: Text(message)));

  void openEditSheet(String? name) {
    if (name == null) return;

    final text =
        '$message\n\t- $name; ${getDateFormatter(timestamp.toDate()).format(timestamp.toDate())}';

    Get.dialog(AlertDialog(
      title: Text('Send to Twitter'),
      content: Text(text),
      actions: [
        ElevatedButton(
            onPressed: () => launch(Uri(
                scheme: 'https',
                path: 'twitter.com/intent/tweet',
                queryParameters: {'text': text}).toString()),
            child: Text('Tweet')),
        TextButton(child: Text('Cancel'), onPressed: Get.back)
      ],
    ));
    // Get.bottomSheet()
  }

  bool isBySameAuthor(Message m) => m.user == user;
  bool isNotTooLongAfter(Message m) =>
      timestamp.toDate().difference(m.timestamp.toDate()).inMinutes < 4;
}

class ChannelDisplayController extends GetxController {
  final FirebaseFirestore firestore = Get.find<FirebaseFirestore>();
  final Rx<DocumentSnapshot?> channel = Rx<DocumentSnapshot?>(null);
  final RxList<Message> messages = <Message>[].obs;
  late final CollectionReference ref;
  late final String key;
  late final GlobalKey<FormBuilderState> formKey;

  ChannelDisplayController({required this.key, required this.formKey});

  @override
  void onInit() {
    ref = firestore.collection('groups').doc(key).collection('messages');

    firestore
        .collection('groups')
        .doc(key)
        .get()
        .then((snap) => channel.value = snap);

    sub = ref.orderBy('timestamp').snapshots().listen((query) {
      messages.clear();

      query.docs.forEach((doc) {
        if (doc.id == '_default_') return;
        messages.add(Message.fromSnapshot(doc));
      });
    })
      ..onError((err) => print(err));

    super.onInit();
  }

  late final sub;

  @override
  void onClose() {
    sub.cancel();
    super.onClose();
  }

  Iterable<Widget> messageWidgets() sync* {
    Message? referenceMessage;
    int index = 0;

    while (index < messages.length) {
      if (index == 0) {
        yield messages[0].toWidget();
        referenceMessage = messages[index++];
        continue;
      }

      Message currentMessage = messages[index];

      if (referenceMessage != null &&
          currentMessage.isBySameAuthor(referenceMessage) &&
          currentMessage.isNotTooLongAfter(referenceMessage)) {
        yield messages[index++].toConsecutiveWidget();
      } else {
        referenceMessage = messages[index - 1];

        yield Padding(padding: EdgeInsets.only(top: 10));
        yield messages[index++].toWidget();
      }
    }
  }

  void writeMessage(String message) async {
    await ref.add({
      'message': message,
      'timestamp': Timestamp.now(),
      'user': firestore
          .collection('profiles')
          .doc(Get.find<FirebaseAuth>().currentUser!.uid)
    });
  }
}

class ChannelDisplayScreen extends Screen<ChannelDisplayController> {
  late final String id;
  late final GlobalKey<FormBuilderState> formKey;

  ChannelDisplayScreen({required this.id})
      : super('', 'messages', true, false, true) {
    formKey = GlobalKey<FormBuilderState>();
    pageController = ChannelDisplayController(key: id, formKey: formKey);
  }

  @override
  AppBar topBar(String title) {
    return AppBar(title: Text(title), actions: []);
  }

  @override
  Widget getFAB() {
    return FloatingActionButton(
      onPressed: () => Get.bottomSheet(
          Container(
              padding: EdgeInsets.all(10),
              height: 80,
              child: FormBuilder(
                key: formKey,
                child: Row(children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: FormBuilderTextField(
                        validator: FormBuilderValidators.required(Get.context!),
                        name: 'input',
                        decoration: InputDecoration(
                            labelText: "Message",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.grey,
                                ))),
                      ),
                    ),
                  ),
                  IconButton(
                    splashRadius: 30,
                    onPressed: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        pageController.writeMessage(
                            formKey.currentState!.value['input'] as String);
                        formKey.currentState!.reset();
                        Get.back();
                      }
                    },
                    icon: Icon(Icons.send),
                  )
                ]),
              )),
          elevation: 100,
          clipBehavior: Clip.none,
          backgroundColor: Get.theme.dialogBackgroundColor),
      child: Icon(Icons.send),
    );
  }

  @override
  Widget body(ChannelDisplayController controller) {
    final DocumentSnapshot? channel = controller.channel.value;

    if (channel == null) {
      return Container();
    } else {
      return Container(
          child: ListView(
        reverse: true,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        children: [
          ...[...controller.messageWidgets()].reversed,
          if (controller.messages.length == 0)
            Center(
                child: Text('The '
                    'beginning of the channel'))
        ],
      ));
    }
  }
}
