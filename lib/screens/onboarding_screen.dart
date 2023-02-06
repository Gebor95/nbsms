// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_images.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/login_screen.dart';
import 'package:nbsms/widgets/onboarding_widget.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: nbSecondarycolor,
      body: Column(
        children: [
          Container(
            clipBehavior: Clip.none,
            height: screenHeight(context) * 0.76,
            child: PageView(
              controller: controller,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 2;
                });
              },
              children: [
                buildPage(
                  color: nbSecondarycolor,
                  urlimage: onboarding1,
                  title: 'Fast Bulk SMS Delivery',
                  subtitle:
                      'We have integrated modern technologies to give you premium and the fastest bulk SMS delivery ever. Test it and see for yourself. Your SMS will deliver to your recipients with your chosen sender ID.',
                ),
                buildPage(
                  color: nbSecondarycolor,
                  urlimage: onboarding2,
                  title: 'We Cover the Globe',
                  subtitle:
                      'We operate in Nigeria but we connect you to the world. We have perfect international SMS delivery. Send bulk SMS to over 210 countries. Extend your marketing reach to the UK, USA, Canada, South Africa, India, Ghana, etc.',
                ),
                buildPage(
                  color: nbSecondarycolor,
                  urlimage: onboarding3,
                  title: 'Customized SMS',
                  subtitle:
                      'Customized SMS otherwise known as Text Merge allows you to address your customers by their names, due payments, etc.',
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.05,
          ),
          Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: WormEffect(
                  spacing: 16.0,
                  dotHeight: 6.0,
                  dotColor: nboffwhite,
                  activeDotColor: nbPrimarycolor),
              onDotClicked: (index) => controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              ),
            ),
          ),
        ],
      ),
      bottomSheet: isLastPage
          ? Padding(
              padding: const EdgeInsets.all(11.0),
              child: SubmitButton(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showOnBoarding', true);
                  goToReplace(context, const LoginScreen());
                },
                text: 'Get Started',
                bgcolor: nbPrimarycolor,
                fgcolor: nbSecondarycolor,
                width: screenWidth(context) * 0.95,
                textStyle: TextStyle(
                    fontWeight: fnt500,
                    fontSize: 16.0,
                    fontFamily: centurygothic),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              height: screenHeight(context) * 0.10,
              color: nbSecondarycolor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => controller.jumpToPage(2),
                      child: Text(
                        "SKIP",
                        style: TextStyle(
                            fontFamily: centurygothic, color: nbPrimarycolor),
                      )),
                  const SizedBox(),
                  TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: nbSecondarycolor,
                          elevation: 2,
                          backgroundColor: nbPrimarycolor),
                      onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          ),
                      child: Text(
                        "NEXT",
                        style: TextStyle(fontFamily: centurygothic),
                      )),
                ],
              ),
            ),
    );
  }
}
