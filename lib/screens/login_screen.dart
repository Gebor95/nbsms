import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_images.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/register_screen.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("login");
    if (val == "logged_in") {
      goToReplace(context, const HomeScreen());
    }
  }

  loginusrrqt() async {
    var data = {
      "username": emailController.text,
      "password": pwordController.text,
      "action": "login",
    };

    final response = await http
        .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == "OK") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', emailController.text);
        prefs.setString('password', pwordController.text);

        if (responseData['full_name'] != null) {
          prefs.setString('userFullName', responseData['full_name']);
        }
        if (responseData['email'] != null) {
          prefs.setString('userEmail', responseData['email']);
        }

        pageRoute("logged_in");
        goToReplace(context, const HomeScreen());
      }
      if (responseData['error'] != "") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
        print(responseData['error']);
      }
    } else {
      // Handle other cases or errors here
      print(response.body);
    }
  }

  void pageRoute(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", status);
    goToReplace(context, const HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                alignment: AlignmentDirectional.topStart,
                children: [
                  Container(
                      height: screenHeight(context) * 0.70,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.elliptical(150, 50),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              nbPrimarydarker,
                              nbPrimarycolor,
                            ],
                          ))),
                  Center(
                    child: Container(
                      width: screenWidth(context) * 0.90,
                      margin: EdgeInsets.only(top: screenHeight(context) * 0.1),
                      height: screenHeight(context) * 0.88,
                      child: Column(
                        children: [
                          Image.asset(
                            textlogo,
                            scale: 1,
                          ),
                          Text(
                            "The Most Used Nigerian SMS Site!",
                            style: TextStyle(color: nbSecondarycolor),
                          ),
                          SizedBox(height: screenHeight(context) * 0.10),
                          Container(
                            height: screenHeight(context) * 0.54,
                            width: screenWidth(context),
                            decoration: BoxDecoration(
                              color: nbSecondarycolor,
                              boxShadow: [
                                BoxShadow(
                                  color: nbshadowcolor,
                                  offset: const Offset(
                                    0.0,
                                    5.0,
                                  ),
                                  blurRadius: 3.0,
                                  spreadRadius: 1.0,
                                ),
                              ],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Login -",
                                      style: TextStyle(
                                          color: fontcolor, fontSize: 20.0),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.05,
                                    ),
                                    TextFormField(
                                        // onChanged: (value) =>
                                        //     loginModel.setUsername(value),
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: "Username | Email",
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter your email';
                                          }
                                          return null;
                                        }),
                                    SizedBox(
                                      height: screenHeight(context) * 0.02,
                                    ),
                                    TextFormField(
                                      // onChanged: (value) =>
                                      //     loginModel.setPassword(value),
                                      controller: pwordController,
                                      obscureText: true,
                                      //obscuringCharacter: '',
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.03,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        goToReplace(
                                            context, const SplashScreen());
                                      },
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "Forgot Password",
                                          style:
                                              TextStyle(color: nbshadowcolor),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.06,
                                    ),
                                    SubmitButton(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          loginusrrqt();
                                        }
                                      },
                                      text: 'Login',
                                      bgcolor: nbPrimarycolor,
                                      fgcolor: nbSecondarycolor,
                                      width: screenWidth(context) * 0.95,
                                      textStyle: TextStyle(
                                          fontWeight: fnt500, fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: screenHeight(context) * 0.06),
                              child: TextButton(
                                  onPressed: () {
                                    goToPush(context, const RegisterAccount());
                                  },
                                  child: const Text("Register Account"))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
