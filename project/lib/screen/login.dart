import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:project/controller/login.dart';
import 'package:supercharged/supercharged.dart';

class LoginScreen extends StatelessWidget {
  final FirebaseAuth auth = Get.put(FirebaseAuth.instance);

  @override
  Widget build(BuildContext context) {
    /* TODO: Seperate Login Email and Email Picker into two different screens
         and change with Get.to */
    return Scaffold(
        body: Container(
            child: Center(
      child: GetBuilder<LoginScreenController>(
          init: LoginScreenController(),
          builder: (val) {
            switch (val.state) {
              case States.EMAIL:
                val.initControllers();
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 196),
                      FormBuilder(
                          key: val.form,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(children: [
                            FormBuilderTextField(
                                name: 'Email',
                                decoration: InputDecoration(
                                    labelText: 'Email',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                validator: FormBuilderValidators.email(context,
                                    errorText: 'Please input a valid email'),
                                keyboardType: TextInputType.emailAddress),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: FormBuilderTextField(
                                  name: 'Password',
                                  decoration: InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(4))),
                                  obscureText: true,
                                  validator:
                                      FormBuilderValidators.required(context)),
                            ),
                          ])),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                                    padding: const EdgeInsets.all(16),
                                    color: Theme.of(context).accentColor,
                                    child: Text('Login with Email'),
                                    onPressed: () async {
                                      val.form.currentState!.save();
                                      if (val.form.currentState!.validate()) {
                                        try {
                                          await auth.signInWithEmailAndPassword(
                                              email: val.form.currentState!
                                                      .value["Email"] ??
                                                  "",
                                              password: val.form.currentState!
                                                      .value["Password"] ??
                                                  "");
                                        } on FirebaseAuthException catch (error) {
                                          switch ((error).code) {
                                            case 'user-not-found':
                                              Get.snackbar(
                                                  'Error',
                                                  'There is no user for this '
                                                      'email',
                                                  backgroundColor:
                                                      "#222".toColor(),
                                                  colorText: "#eee".toColor(),
                                                  forwardAnimationCurve:
                                                      Curves.linear,
                                                  reverseAnimationCurve:
                                                      Curves.linear,
                                                  animationDuration: Duration(
                                                      milliseconds: 500),
                                                  duration:
                                                      Duration(seconds: 1));
                                              break;
                                            case 'wrong-password':
                                              Get.snackbar(
                                                  'Error', 'Wrong password!',
                                                  backgroundColor:
                                                      "#222".toColor(),
                                                  colorText: "#eee".toColor(),
                                                  forwardAnimationCurve:
                                                      Curves.linear,
                                                  reverseAnimationCurve:
                                                      Curves.linear,
                                                  animationDuration: Duration(
                                                      milliseconds: 500),
                                                  duration:
                                                      Duration(seconds: 1));
                                          }
                                        }
                                      }
                                    })),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              case States.PICKER:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 196),
                    SignInButton(
                      Buttons.Email,
                      onPressed: () {
                        val.changeState(States.EMAIL);
                      },
                      padding: EdgeInsets.all(16),
                    )
                  ],
                );
            }
          }),
    )));
  }
}
