import 'dart:convert';

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
import 'package:http/http.dart' as http;

class DrawerWidgt extends StatefulWidget {
  const DrawerWidgt({super.key});

  @override
  State<DrawerWidgt> createState() => _DrawerWidgtState();
}

class _DrawerWidgtState extends State<DrawerWidgt> {
  String? name = '';
  String? email = '';
  Future<void>? _fetchProfileFuture;

  @override
  void initState() {
    super.initState();
    _fetchProfileFuture = _fetchProfile();
  }

  @override
  void dispose() {
    // Cancel the asynchronous operation when the widget is disposed.
    _fetchProfileFuture?.whenComplete(() {});
    super.dispose();
  }

  Future<Map<String, dynamic>?> fetchProfile(
      String username, String password) async {
    var data = {
      "username": username,
      "password": password,
      "action": "profile", // Use a different action to fetch the balance
    };

    final response = await http
        .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      setState(
        () {
          name = data['name'];
          email = data['email'];
        },
      );

      return responseData;
    } else {
      return null;
    }
  }

  Future<void> _fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    Map<String, dynamic>? fetchedProfile = await fetchProfile(
        username, password); // Call the method from api_service.dart
    if (fetchedProfile != null) {
      if (mounted) {
        setState(() {
          name = fetchedProfile['name'];
          email = fetchedProfile['email'];
        });
      }
    } else {
      print("Error fetching profile");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              accountName: Text(
                name!,
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                email!,
              ),
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
