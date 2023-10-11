import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider_app/const/firebase_const.dart';
import 'package:provider_app/screens/dashboard_screen.dart';
import 'package:provider_app/screens/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  //change screen
  changeScreen(){
    Future.delayed(Duration(seconds: 2), () {
      //Get.to(() => SignInScreen());
      auth.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.offAll(() => SignInScreen());
        } else {
          Get.offAll(() => DashboardScreen());
        }
      });
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  /*void init() async {
    Timer(
      Duration(seconds: 2),
      () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WalkThroughScreen()),
          (route) => false,
        );
        auth.authStateChanges().listen((User? user) {
          if (user == null && mounted) {
            Get.to(() => SignInScreen());
          } else {
            Get.to(() => DashBoardScreen());
          }
        });
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/repair.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 16.0),
            Text(
              'Provider App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              'Connecting You to the Best Services',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
