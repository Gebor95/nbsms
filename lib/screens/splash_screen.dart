// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_images.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'dart:async';

import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/entry.dart';
import 'package:nbsms/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final showOnBoarding = prefs.getBool('showOnBoarding');
      if (showOnBoarding == true) {
        goToReplace(context, const AppEntryPoint());
      } else {
        goToReplace(context, const OnboardingScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nbPrimarycolor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: screenHeight(context) * 0.25),
          Container(
            child: splashicon,
          ),
          SizedBox(height: screenHeight(context) * 0.5),
          Container(
            child: splashlogo,
          ),
        ],
      ),
    );
  }
}
