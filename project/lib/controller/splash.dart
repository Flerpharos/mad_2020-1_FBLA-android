import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  int _value = 0;
  bool _running = true;

  double get value => _value / 120;

  @override
  void onReady() {
    Future.doWhile(() async {
      _value = (_value + 1) % 120;
      update();
      await Future.delayed(const Duration(milliseconds: 1));
      return _running;
    });
    super.onReady();
  }

  @override
  void onClose() {
    _running = false;
    super.onClose();
  }
}
