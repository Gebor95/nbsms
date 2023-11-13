import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/model/user.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/login_screen.dart';
import 'package:nbsms/screens/mobile_extractor_screen.dart';
import 'package:nbsms/screens/payment_history.dart';
import 'package:nbsms/screens/personal_contact_screen.dart';
import 'package:nbsms/screens/profile_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/screens/splash_screen.dart';
import 'package:nbsms/widgets/message_history_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String? name = '';
  String? email = '';
  late UserProfileProvider _userProfileProvider;
  // final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    _userProfileProvider =
        Provider.of<UserProfileProvider>(context, listen: false);
    _fetchProfile();
  }

  @override
  void dispose() {
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

    try {
      final response = await fetchProfile(username, password);

      if (response != null) {
        _userProfileProvider.setProfile(response['name'], response['email']);
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exceptions, such as network errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfileProvider>(context);
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
                userProfile.name ?? '',
                style: const TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                userProfile.email ?? '',
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
                  goToPush(context, const MessageWidget());
                },
              ),
              ListTile(
                title: const Text("Payments"),
                onTap: () {
                  goToPush(context, const PaymentHistory());
                },
              ),
            ],
          ),

          ListTile(
            leading: const Icon(Icons.wechat_sharp),
            title: const Text('Support'),
            onTap: () {
              goToReplace(context, const SplashScreen());
            },
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
              // _navigatorKey.currentState?.pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (_) => const LoginScreen()),
              //     (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
