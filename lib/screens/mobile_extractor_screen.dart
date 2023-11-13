import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/body_singlescroll_widget.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/drawer_widget.dart';

class MobileExScreen extends StatefulWidget {
  const MobileExScreen({super.key});

  @override
  State<MobileExScreen> createState() => _MobileExScreenState();
}

class _MobileExScreenState extends State<MobileExScreen> {
  bool isExtract = false;
  checkExtract() {
    isExtract = true;
  }

  String balance = " Loading";
  TextEditingController inputController = TextEditingController();
  TextEditingController outputController = TextEditingController();
  List<String> filteredNumbers = [];
  String count = "";
  void filterNumbers() {
    String inputText = inputController.text;
    List<String> numbers = inputText.split(' ');
    var uniqueNumbers = <String>{};

    for (String number in numbers) {
      String cleanedNumber =
          number.replaceAll(RegExp(r'\s+'), '').replaceAll('+', '');

      if (cleanedNumber.startsWith('2340')) {
        cleanedNumber = '0${cleanedNumber.substring(4)}';
      }
      if (cleanedNumber.startsWith('234')) {
        cleanedNumber = '0${cleanedNumber.substring(3)}';
      }

      if (cleanedNumber.length == 11 ||
          cleanedNumber.length == 14 ||
          cleanedNumber.length == 15) {
        if (cleanedNumber.startsWith('081') ||
            cleanedNumber.startsWith('070') ||
            cleanedNumber.startsWith('090') ||
            cleanedNumber.startsWith('091') ||
            cleanedNumber.startsWith('071') ||
            cleanedNumber.startsWith('080')) {
          uniqueNumbers.add(cleanedNumber);
        }
      }
    }

    filteredNumbers = uniqueNumbers.toList();
    outputController.text = filteredNumbers.join('\n');
  }

  @override
  void initState() {
    super.initState();
    // _fetchBalance();
    _loadSavedBalance();
  }

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
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
      body: BodyPaddingWidget(children: [
        const PageTitle(
          text: "Mobile Extractor",
        ),
        SizedBox(
          height: screenHeight(context) * 0.06,
        ),
        TextFormField(
          controller: inputController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: "Paste Numbers",
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  width: 1, color: Colors.greenAccent), //<-- SEE HERE
            ),
            label: Text("Mobiles"),
          ),
        ),
        SizedBox(
          height: screenHeight(context) * 0.02,
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
        SubmitButton(
          onTap: () {
            filterNumbers();
          },
          text: 'Extract Numbers',
          bgcolor: nbPrimarycolor,
          fgcolor: nbSecondarycolor,
          width: screenWidth(context) * 0.95,
          textStyle: TextStyle(fontWeight: fnt500, fontSize: 16.0),
        ),
        TextField(
          controller: outputController,
          maxLines: 10,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Filtered Numbers'),
        ),
        SizedBox(
          height: screenHeight(context) * 0.04,
        ),
      ]),
    );
  }
}
