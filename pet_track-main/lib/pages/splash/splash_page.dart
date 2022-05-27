import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pet_track/pages.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  Future<void> checkAuth() async {
    auth.authStateChanges().listen((event) {
      Get.toNamed(event != null ? Pages.home : Pages.auth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(strokeWidth: 1)),
    );
  }
}
