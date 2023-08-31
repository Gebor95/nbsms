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
  final Contactt contact;
  const SendMessage({super.key, required this.contact});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String balance = ' Loading';
  final TextEditingController recipientsController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

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
    recipientsController.text = widget.contact.mobile;
  }

  Future<void> _sendMessage() async {
    const snack = SnackBar(
      content: Text("Sending"),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    String recipients = recipientsController.text;
    String senderName = senderNameController.text;
    String message = messageController.text;

    try {
      final response = await sendMessage(
          username, password, recipients, senderName, message);

      final status = response['status'];
      final count = response['count'];
      final price = response['price'];

      if (status == 'OK') {
        double messageCost = double.parse(price.toString());
        double currentBalance = double.parse(balance.replaceAll('₦', ''));
        double newBalance = currentBalance - messageCost;

        // Update the state to reflect the new balance
        setState(() {
          balance = '$newBalance';
        });

        // Update the saved balance in SharedPreferences
        prefs.setString('balance', '$newBalance');

        recipientsController.clear();
        senderNameController.clear();
        messageController.clear();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Message Sent'),
            content: Text(
              'Status: $status\nCount: $count\nPrice: ₦$price',
              style: TextStyle(fontFamily: roboto),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Message sending failed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred while sending the message.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
                height: screenHeight(context) * 0.02,
              ),
              TextFormField(
                maxLines: 3,
                controller: recipientsController,
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
                controller: senderNameController,
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
                controller: messageController,
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
                onTap: _sendMessage,
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
