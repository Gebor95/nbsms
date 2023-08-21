import 'package:flutter/material.dart';

import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/body_colum_widget.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/personal_contact_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/drawer_widget.dart';

class PersonalContScreen extends StatefulWidget {
  const PersonalContScreen({super.key});

  @override
  State<PersonalContScreen> createState() => _PersonalContScreenState();
}

class _PersonalContScreenState extends State<PersonalContScreen> {
  String balance = " Loading";
  bool nocontact = false;
  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leadingWidth: screenWidth(context) * 0.09,
        titleTextStyle: TextStyle(fontSize: 16.0, fontFamily: centurygothic),
        backgroundColor: nbPrimarycolor,
        foregroundColor: nbSecondarycolor,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(
                Icons.menu,
                color: nbSecondarycolor,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: RichText(
          // Controls visual overflow
          overflow: TextOverflow.clip,

          // Controls how the text should be aligned horizontally
          textAlign: TextAlign.end,

          // Control the text direction
          textDirection: TextDirection.rtl,

          // Whether the text should break at soft line breaks
          softWrap: true,

          // Maximum number of lines for the text to span
          maxLines: 1,

          // The number of font pixels for each logical pixel
          textScaleFactor: 1,
          text: TextSpan(
            text: 'Balance: ',
            style: TextStyle(fontFamily: centurygothic, fontSize: 16.0),
            children: <TextSpan>[
              TextSpan(text: '₦', style: TextStyle(fontFamily: roboto)),
              TextSpan(text: balance),
            ],
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                goToPush(context, const RechargeScreen());
              },
              icon: Icon(
                Icons.shopping_cart,
                color: nbSecondarycolor,
              )),
          IconButton(
              onPressed: () {
                goToPush(context, const NotificationScreen());
              },
              icon: Icon(
                Icons.notifications_active,
                color: nbSecondarycolor,
              ))
        ],
      ),
      drawer: const DrawerWidget(),
      body: BodyColWidget(
        children: [
          const PageTitle(text: "Personal Contacts"),
          SizedBox(height: screenHeight(context) * 0.03),
          nocontact
              ? Container(
                  clipBehavior: Clip.none,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenHeight(context) * 0.15,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: screenWidth(context) * 0.40,
                        height: screenWidth(context) * 0.40,
                        decoration: BoxDecoration(
                          color: nbPrimarycolor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          size: screenWidth(context) * 0.30,
                          Icons.person_add,
                          color: nbSecondarycolor,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      const Center(
                          child:
                              Text("You have not saved a personal contact!")),
                    ],
                  ),
                )
              : const Expanded(
                  child: PersonalContWidget(),
                )
        ],
      ),
    );
  }
}
