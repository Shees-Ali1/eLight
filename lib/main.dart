import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/home_section/home_page.dart';
import 'dart:async';
import 'package:flutter/services.dart';

void main() {
  // Set the preferred orientation to portrait
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

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
            ),
            const SizedBox(height: 1),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
              ),
              padding: const EdgeInsets.all(5),
              child: const Text(
                'Flip horizontal',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
