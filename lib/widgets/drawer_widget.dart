import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/login_screen.dart';
import 'package:nbsms/screens/mobile_extractor_screen.dart';
import 'package:nbsms/screens/personal_contact_screen.dart';
import 'package:nbsms/screens/profile_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidgt extends StatelessWidget {
  const DrawerWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    void logout() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('username');
      prefs.remove('password');
      prefs.setString('login', 'logged_out');
      goToPush(context, const SplashScreen());
    }

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: nbPrimarydarker,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: nbPrimarydarker),
              accountName: const Text(
                "Ese Smith Echanomi",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: const Text("esesmithechanomi@gmail.com"),
            ), //UserAccountDrawerHeader
          ), //DrawerHeader

          ExpansionTile(
            title: const Text("My Account"),
            leading: const Icon(Icons.person_rounded), //add icon
            childrenPadding: const EdgeInsets.only(left: 60), //children padding
            children: [
              ListTile(
                title: const Text("Profile"),
                onTap: () {
                  //action on press
                  goToPush(context, const ProfileScreen());
                },
              ),
              ListTile(
                title: const Text("Recharge"),
                onTap: () {
                  //action on press
                  goToReplace(context, const RechargeScreen());
                },
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Mobile Extractor'),
            onTap: () {
              goToReplace(context, const MobileExScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Send Message'),
            onTap: () {
              goToReplace(context, const HomeScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Personal Contacts'),
            onTap: () {
              goToReplace(context, const PersonalContScreen());
            },
          ),

          ExpansionTile(
            title: const Text("Reports"),
            leading: const Icon(Icons.table_chart), //add icon
            childrenPadding: const EdgeInsets.only(left: 60), //children padding
            children: [
              ListTile(
                title: const Text("Messages"),
                onTap: () {
                  //action on press
                },
              ),
              ListTile(
                title: const Text("Payments"),
                onTap: () {
                  //action on press
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.clear();

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            },
          ),
          ListTile(
            leading: const Icon(Icons.whatshot_sharp),
            title: const Text('Support'),
            onTap: () {
              goToReplace(context, const SplashScreen());
            },
          ),
        ],
      ),
    );
  }
}
