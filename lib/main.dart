import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/home_section/home_page.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  )); // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // Navigate to the MyHomePage screen
      Get.off(() =>  const MyHomePage(title: 'Home'));
    });


    return Scaffold(
       backgroundColor: const Color(0xFFB2F5E4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Logo.png',
              width: 500,
              // height: 400,
            ),
            
            // const Text(
            //   'Flip Phone to Horizontal',
            //   style: TextStyle(fontSize: 10, color: Colors.white),
            // ),
          ],
        ),
      ),
    );
  }
}




