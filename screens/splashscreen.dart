import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectt/authontication/welcomepage.dart';

import 'endpoint.dart';
import 'mainscreens.dart';
import 'onboardingscreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Widget widget;
    if(asGuest != null)
    {
      widget = mainScreens();
    }
    else {
      if (onBoarding != null) {
        if (token != null) {
          widget = mainScreens();
        } else {
          widget = const WelcomePage();
        }
      } else {
        widget = const OnBoardingScreen();
      }
    }
    super.initState();
    Timer(Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                widget
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          height: 280,
          width: 280,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: const DecorationImage(
                image: AssetImage("images/logo.jfif"),
                fit: BoxFit.cover,

              )
          ),
        ),
      ),
    );
  }
}
