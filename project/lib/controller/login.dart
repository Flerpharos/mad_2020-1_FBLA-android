import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

enum States { EMAIL, PICKER }

class LoginScreenController extends GetxController {
  late final GlobalKey<FormBuilderState> form;

  bool _init = false;

  States state = States.PICKER;

  void initControllers() {
    if (_init) return;
    form = GlobalKey<FormBuilderState>();
    _init = true;
  }

  void changeState(States state) {
    this.state = state;
    update();
  }
}
