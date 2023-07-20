import 'package:flutter/material.dart';
import 'package:nbsms/api_service/api.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/widgets/body_singlescroll_widget.dart';
import 'package:nbsms/widgets/drawer_widget.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
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

  @override
  void initState() {
    super.initState();
    _fetchBalance();
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
      drawer: const DrawerWidgt(),
      body: BodyPaddingWidget(children: [
        const PageTitle(
          text: "Recharge Account",
        ),
        SizedBox(
          height: screenHeight(context) * 0.06,
        ),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "min 500",
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Colors.greenAccent), //<-- SEE HERE
            ),
            label: Text("Amount"),
          ),
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
        SubmitButton(
          onTap: () {
            goToReplace(context, const HomeScreen());
          },
          text: 'Recharge Account',
          bgcolor: nbPrimarycolor,
          fgcolor: nbSecondarycolor,
          width: screenWidth(context) * 0.95,
          textStyle: TextStyle(fontWeight: fnt500, fontSize: 16.0),
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
        const Text(
            "For Cash Transfer pay into the below account and send our support a message via the whatsapp customer chat line "),
      ]),
    );
  }
}
