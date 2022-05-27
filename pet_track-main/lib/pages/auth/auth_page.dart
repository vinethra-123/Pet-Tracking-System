import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pet_track/pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> _loginUser(LoginData data) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: data.name,
        password: data.password,
      );
    } on FirebaseAuthException catch (e) {
      return e.message ?? "There was an error!";
    } catch (e) {
      return "There was an error";
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    if (data.name == null || data.password == null) {
      return "Fields cannot be empty";
    }
    try {
      await auth.createUserWithEmailAndPassword(
        email: data.name!,
        password: data.password!,
      );
    } on FirebaseAuthException catch (e) {
      return e.message ?? "There was an error!";
    } catch (e) {
      return "There was an error";
    }
  }

  Future<String> _recoverPassword(String name) async {
    try {
      await auth.sendPasswordResetEmail(email: name);
      return "Email was sent to $name";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "There was an error!";
    } catch (e) {
      return "There was an error, Please try again!";
    }
  }

  Future<String?> _googleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await auth.signInWithCredential(credential);
    } catch (e) {
      // print(e);
      return "There was an error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'PET TRACK',
      onLogin: _loginUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      loginProviders: <LoginProvider>[
        LoginProvider(
          icon: FontAwesomeIcons.google,
          label: 'Google',
          callback: _googleSignIn,
        ),
      ],
      onSubmitAnimationCompleted: () => Get.toNamed(Pages.home),
    );
  }
}
