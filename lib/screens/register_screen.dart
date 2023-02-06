import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({super.key});

  @override
  State<RegisterAccount> createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nbPrimarycolor,
      appBar: AppBar(
        title: const Text("Welcome 🤝"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              Container(
                height: screenHeight(context) * 0.73,
                width: screenWidth(context),
                decoration: BoxDecoration(
                  color: nbSecondarycolor,
                  boxShadow: [
                    BoxShadow(
                      color: nbPrimarydarker,
                      offset: const Offset(
                        1.0,
                        1.0,
                      ),
                      blurRadius: 5.0,
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
                          "Register -",
                          style: TextStyle(color: fontcolor, fontSize: 20.0),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.05,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Contact Name",
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Contact Mobile",
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Username | Email",
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        TextFormField(
                          obscureText: true,
                          //obscuringCharacter: '',
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Referral Code (optional)",
                          ),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.06,
                        ),
                        SubmitButton(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showOnBoarding', false);
                            // ignore: use_build_context_synchronously
                            goToReplace(context, const SplashScreen());
                          },
                          text: 'Register',
                          bgcolor: nbPrimarycolor,
                          fgcolor: nbSecondarycolor,
                          width: screenWidth(context) * 0.95,
                          textStyle:
                              TextStyle(fontWeight: fnt500, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
