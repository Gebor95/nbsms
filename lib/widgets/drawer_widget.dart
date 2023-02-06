import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/call_message_screen.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/mobile_extractor_screen.dart';
import 'package:nbsms/screens/personal_contact_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:nbsms/screens/tts_screen.dart';

class DrawerWidgt extends StatelessWidget {
  const DrawerWidgt({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: nboldprimarycolor,
            ), //BoxDecoration
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: nboldprimarycolor),
              accountName: const Text(
                "Okosisi Joseph",
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: const Text("josephokosisi@gmail.com"),
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
                },
              ),
              ListTile(
                title: const Text("Pricing"),
                onTap: () {
                  //action on press
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
          ExpansionTile(
            title: const Text("Messaging"),
            leading: const Icon(Icons.chat), //add icon
            childrenPadding: const EdgeInsets.only(left: 60), //children padding
            children: [
              ListTile(
                title: const Text("Text Message"),
                onTap: () {
                  goToReplace(context, const HomeScreen());
                },
              ),
              ListTile(
                title: const Text("Call Message"),
                onTap: () {
                  //action on press
                  goToReplace(context, const CallMessScreen());
                },
              ),
              ListTile(
                title: const Text("Text To Speech"),
                onTap: () {
                  //action on press
                  goToReplace(context, const TtsScreen());
                },
              ),
            ],
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
              ListTile(
                title: const Text("Delivery"),
                onTap: () {
                  //action on press
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              goToReplace(context, const SplashScreen());
            },
          ),
          ListTile(
            leading: const Icon(Icons.whatsapp_sharp),
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
