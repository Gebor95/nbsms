import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/message_history_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/drawer_widget.dart';

class MessageDetailsScreen extends StatefulWidget {
  const MessageDetailsScreen({super.key});

  @override
  State<MessageDetailsScreen> createState() => _MessageDetailsScreenState();
}

class _MessageDetailsScreenState extends State<MessageDetailsScreen> {
  String balance = " Loading";
  bool noMessage = false;

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  final smsCatCtrl = TextEditingController();
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
      body: Column(
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10),
                  Text(
                    '   Messages',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 18, right: 20),
                child: Container(
                  clipBehavior: Clip.none,
                  width: 170,
                  height: 50,
                  child: CustomDropdown(
                    fieldSuffixIcon: const Icon(
                      Icons.arrow_drop_down_sharp,
                      size: 25,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.black12),
                    selectedStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    hintText: 'Delivered',
                    hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                    items: const [
                      'Delivered',
                      'Submitted',
                      'DND',
                      'Failed',
                    ],
                    controller: smsCatCtrl,
                  ),
                ),
              ),
            ],
          ),
          const Gap(20),
          noMessage
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
                      const Center(child: Text("You Have No Message Yet!")),
                    ],
                  ),
                )
              : const Expanded(
                  child: MessageWidget(),
                )
          //
        ],
      ),
    );
  }
}
