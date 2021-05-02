import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  bool _complete = false;
  bool _err = false;

  bool get err => _err;
  bool get done => _complete;

  @override
  void onReady() {
    Firebase.initializeApp()
        .then((val) => _complete = true)
        .onError((_, __) => _err = true)
        .whenComplete(() => update());
    super.onReady();
  }
}
