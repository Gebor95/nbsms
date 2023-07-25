import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nbsms/api/api_service.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/drawer_widget.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String balance = ' Loading';
  Future<void> _fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    String fetchedBalance = await fetchBalance(
        username, password); // Call the method from api_service.dart
    setState(() {
      balance =
          fetchedBalance; // Update the balance variable with the fetched value
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchBalance();
  }

  // Initial Selected Value
  String dropdownvalue = 'New Contacts';

  // List of items in our dropdown menu
  var items = [
    'New Contacts',
    'Personal Contacts',
    'Device Contacts',
  ];

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
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(
                text: "Text Message",
              ),
              // SizedBox(
              //   height: screenHeight(context) * 0.06,
              // ),
              // DropdownButtonFormField(
              //   value: dropdownvalue,
              //   items: items.map((String items) {
              //     return DropdownMenuItem(
              //       value: items,
              //       child: Text(items),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownvalue = newValue!;
              //     });
              //   },
              //   decoration: const InputDecoration(
              //     alignLabelWithHint: true,
              //     border: OutlineInputBorder(
              //       borderSide: BorderSide(
              //           width: 1, color: Colors.greenAccent), //<-- SEE HERE
              //     ),
              //     labelText: "Select Contact",
              //   ),
              // ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Seperate each phone number with a space",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                  label: Text("Recipients"),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.04,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: "OSPIVV",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                  label: Text("Sender Name"),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.04,
              ),
              TextFormField(
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: "Message",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                  label: Text("Message"),
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.04,
              ),
              SubmitButton(
                onTap: () {
                  goToReplace(context, const SendMessage());
                },
                text: 'Send Message',
                bgcolor: nbPrimarycolor,
                fgcolor: nbSecondarycolor,
                width: screenWidth(context) * 0.95,
                textStyle: TextStyle(fontWeight: fnt500, fontSize: 16.0),
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
