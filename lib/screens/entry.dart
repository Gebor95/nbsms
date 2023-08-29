import 'package:flutter/material.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppEntryPoint extends StatefulWidget {
  const AppEntryPoint({super.key});

  @override
  State<AppEntryPoint> createState() => _AppEntryPointState();
}

class _AppEntryPointState extends State<AppEntryPoint> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val = prefs.getString("login");
    if (val == "logged_in") {
      setState(() {
        _isLoggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
