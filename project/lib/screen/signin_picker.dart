import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:twitter_login/twitter_login.dart';

class SignInPickerScreen extends StatefulWidget {
  @override
  _SignInPickerScreenState createState() => _SignInPickerScreenState();
}

class _SignInPickerScreenState extends State<SignInPickerScreen> {
  late final TwitterLogin _twitterLogin;
  var login;

  @override
  void initState() {
    _twitterLogin = TwitterLogin(
        apiKey: 'JPxsTlVatn7wUv41cgpdeAGQQ',
        apiSecretKey: 'e6tpA5HYT4kdpzoKqHbWBOpGfdopxrRtDjtVz7T56DE0Mxu2JA',
        redirectURI: 'flerpapp://');
    super.initState();
  }

  Future<String?> twitterLogin() async {
    try {
      this.login = await _twitterLogin.login();

      if (login.status == TwitterLoginStatus.error || login.status == null)
        return login.errorMessage;
      if (login.status == TwitterLoginStatus.cancelledByUser)
        return 'Login Cancelled';
      else if (login.status == TwitterLoginStatus.loggedIn) {
        return 'haha its just firebase i hate it';
      }
    } catch (err) {
      return err.toString();
    }
  }

  Future<String?> signIn(LoginData data) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: data.name, password: data.password);
    } catch (err) {
      if (err is FirebaseAuthException) return err.message;
      return 'Login failed with unknown error';
    }
  }

  Future<String?> signUp(LoginData data) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: data.name, password: data.password);
    } catch (err) {
      if (err is FirebaseAuthException) return err.message;
      return 'Sign Up failed with unknown error';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (login?.status == TwitterLoginStatus.loggedIn)
      FirebaseAuth.instance.signInWithCredential(TwitterAuthProvider.credential(
          accessToken: login.authToken!, secret: login.authTokenSecret!));

    return Scaffold(
        body: FlutterLogin(
      loginAfterSignUp: true,
      messages: LoginMessages(
          recoverPasswordDescription: 'An email will be sent with instructions '
              'to reset your password',
          providersTitle: 'or login with'),
      title: 'Six Degrees',
      logo: 'assets/degrees.png',
      hideForgotPasswordButton: true,
      onLogin: signIn,
      onSignup: signUp,
      onRecoverPassword: (password) async {},
      loginProviders: [
        LoginProvider(
            icon: FontAwesomeIcons.google,
            callback: () async {
              try {
                final user = await GoogleSignIn().signIn();
                final auth = await user!.authentication;

                await FirebaseAuth.instance.signInWithCredential(
                    GoogleAuthProvider.credential(
                        accessToken: auth.accessToken, idToken: auth.idToken));
              } catch (err) {
                return err.toString();
              }
            }),
        LoginProvider(
            icon: FontAwesomeIcons.facebookF,
            callback: () async {
              try {
                await FirebaseAuth.instance.signInWithCredential(
                    FacebookAuthProvider.credential(
                        (await FacebookAuth.instance.login())
                            .accessToken!
                            .token));
              } catch (err) {
                return err.toString();
              }
            }),
        //LoginProvider(icon: FontAwesomeIcons.twitter, callback: twitterLogin)
      ],
      //theme: LoginTheme()
    ));
  }
}
