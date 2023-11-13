import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_images.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool _isLoggingIn = false;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void _showSnackBar(String message) {
    _scaffoldMessengerKey.currentState
        ?.showSnackBar(SnackBar(content: Text(message)));
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString("login");
    if (val == "logged_in") {
      navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  loginusrrqt() async {
    setState(() {
      _isLoggingIn = true;
    });

    var data = {
      "username": emailController.text,
      "password": pwordController.text,
      "action": "login",
    };

    try {
      final response = await http.post(
          Uri.parse("https://portal.fastsmsnigeria.com/api/?"),
          body: data);

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
          navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          _showSnackBar("Invalid Credentials");
          // ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text("Invalid Credentials")));
        }
      } else {}
    } catch (error) {
      // Handle any exceptions that may occur during the HTTP request
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  void pageRoute(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", status);
    navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    //final userProvider = Provider.of<UserProvider>(context);

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
                                      },
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.02,
                                    ),
                                    TextFormField(
                                      controller: pwordController,
                                      obscureText: !_passwordVisible,
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
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
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      child: Link(
                                        uri: Uri.parse(
                                            'https://portal.nigeriabulksms.com/password/'),
                                        builder: (context, followLink) =>
                                            TextButton(
                                          onPressed: followLink,
                                          child: const Text("Forgot Password"),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight(context) * 0.04,
                                    ),
                                    SubmitButton(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          loginusrrqt();
                                        }
                                      },
                                      text: _isLoggingIn
                                          ? ''
                                          : 'Login', // Hide text while logging in
                                      bgcolor: nbPrimarycolor,
                                      fgcolor: nbSecondarycolor,
                                      width: screenWidth(context) * 0.95,
                                      textStyle: TextStyle(
                                        fontWeight: fnt500,
                                        fontSize: 16.0,
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Visibility(
                                            visible: _isLoggingIn,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              backgroundColor: Colors
                                                  .grey, // Set the background color
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          ),
                                          Visibility(
                                            visible: !_isLoggingIn,
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                color: nbSecondarycolor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(
                                  top: screenHeight(context) * 0.05),
                              child: Link(
                                uri: Uri.parse(
                                    'https://portal.nigeriabulksms.com/register'),
                                builder: (context, followLink) => TextButton(
                                  onPressed: followLink,
                                  child: const Text("Register Account"),
                                ),
                              ))
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
