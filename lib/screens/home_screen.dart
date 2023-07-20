import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nbsms/api_service/api.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/drawer_widget.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String balance = "";

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
  // Future<void> _fetchBalance() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String username = prefs.getString('username') ?? '';
  //   String password = prefs.getString('password') ?? '';

  //   var data = {
  //     "username": username,
  //     "password": password,
  //     "action": "balance", // Use a different action to fetch the balance
  //   };

  //   final response = await http
  //       .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  //   if (response.statusCode == 200) {
  //     var responseData = jsonDecode(response.body);
  //     setState(() {
  //       balance = responseData['balance'].toString();
  //     });
  //   } else {
  //     // Handle API call failure
  //     setState(() {
  //       balance = "Error fetching balance";
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    Timer(const Duration(), () {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text(
            'Dear valued customer',
            style: TextStyle(fontSize: 17.0, fontWeight: fnt600),
          ),
          content: const Text(
              'Please TEST your message to one or two numbers before sending it to BULK numbers. This is important because network providers have the explicit right to block any content or sender at their discretion without refund.\r\n\r\nPlease note that this does not affect API users who are sending pre-approved transactional messages.\r\n\r\nHowever, if you are having a delivery issue with your message, contact us and we shall be more than happy to assist.\r\n\r\nThank you so much for your kind patronage and understanding.'),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: nbSecondarycolor,
                    backgroundColor: nbPrimarycolor),
                onPressed: () => goToPop(context),
                child: const Text("Ok")),
          ],
        ),
      );
    });
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
      drawer: const DrawerWidgt(),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(
                text: "Text Message",
              ),
              SizedBox(
                height: screenHeight(context) * 0.06,
              ),
              DropdownButtonFormField(
                value: dropdownvalue,
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });
                },
                decoration: const InputDecoration(
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 1, color: Colors.greenAccent), //<-- SEE HERE
                  ),
                  labelText: "Select Contact",
                ),
              ),
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
                  goToReplace(context, const HomeScreen());
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
