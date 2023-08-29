import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? name = '';
  String? username = '';
  String? email = '';
  String? mobile = '';
  String? sender = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
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
          mobile = data['mobile'];
          sender = data['sender'];
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

    // Try to fetch the saved profile from SharedPreferences
    String? savedProfileJson = prefs.getString('profile');
    if (savedProfileJson != null) {
      Map<String, dynamic> savedProfile = jsonDecode(savedProfileJson);
      setState(() {
        name = savedProfile['name'];
        email = savedProfile['email'];
        mobile = savedProfile['mobile'];
        sender = savedProfile['sender'];
      });
    } else {
      // If not saved, fetch profile from API
      Map<String, dynamic>? fetchedProfile =
          await fetchProfile(username, password);
      if (fetchedProfile != null) {
        setState(() {
          name = fetchedProfile['name'];
          email = fetchedProfile['email'];
          mobile = fetchedProfile['mobile'];
          sender = fetchedProfile['sender'];
        });
        // Save the fetched profile in SharedPreferences
        prefs.setString('profile', jsonEncode(fetchedProfile));
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: screenWidth(context) * 0.09,
        titleTextStyle: TextStyle(fontSize: 16.0, fontFamily: centurygothic),
        backgroundColor: nbPrimarycolor,
        foregroundColor: nbSecondarycolor,
        // elevation: 5,\
        leading: IconButton(
          onPressed: () {
            goToPush(context, const HomeScreen());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            clipBehavior: Clip.none,
            width: double.infinity,
            height: 300,
            child: Image.asset(
              'assets/images/contt.jfif',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SENDER NAME",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        sender!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                const Divider(
                  height: 5,
                  color: Colors.black,
                ),
                const Text(
                  "PHONE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        mobile!,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const Gap(1.0),
                      const Spacer(),
                    ],
                  ),
                ),
                const Gap(20),
                const Divider(
                  height: 5,
                  color: Colors.black,
                ),
                const Text(
                  "EMAIL/USERNAME",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text(
                          email!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
