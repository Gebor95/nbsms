import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 5,
        leading: const Icon(Icons.arrow_back_ios),
        title: const Text("Profile"),
        actions: const [
          Icon(Icons.star_outline),
          SizedBox(
            width: 10,
          ),
          Icon(Icons.more_vert),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Image.asset(
            'assets/images/contact.png',
            width: double.infinity,
          ),
          const Gap(20),
          const Padding(
            padding: EdgeInsets.only(
              left: 25.0,
              right: 25.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PHONE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Divider(
                  height: 5,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "+234810000003",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Gap(1.0),
                      Spacer(),
                      Icon(Icons.message),
                    ],
                  ),
                ),
                Text(
                  "MOBILE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                Gap(20),
                Text(
                  "EMAIL",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Divider(
                  height: 5,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "info.chukcyy@gmail.com",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Text(
                  "HOME",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                Gap(20),
                Text(
                  "ADDRESS",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                Divider(
                  height: 5,
                  color: Colors.black,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        "Test Address",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Text(
                  "CUSTOM TAG",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
              ],
            ),
          ),
        ]),
      ),
    ));
  }
}
