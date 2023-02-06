import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
                Icons.arrow_back,
                color: nbSecondarycolor,
              ),
              onPressed: () {
                goToPop(context);
              },
            );
          },
        ),
        title: const Text('Notifications'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active,
                color: nbSecondarycolor,
              ))
        ],
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: screenWidth(context) * 0.05,
          right: screenWidth(context) * 0.05,
          top: screenHeight(context) * 0.05,
          bottom: screenHeight(context) * 0.05,
        ),
        children: [
          ListBody(
            children: [
              Text(
                "OTP/Transactional Messages for API Users",
                style: TextStyle(fontWeight: fnt600),
              ),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              const Text(
                  "Do you want to send OTP or other transactional messages through API? Contact us to configure your account for it."),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          const Divider(),
          ListBody(
            children: [
              Text(
                "MTN Delivery Time Restrictions",
                style: TextStyle(fontWeight: fnt600),
              ),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              const Text(
                  "As per directives from NCC (Nigerian Communications Commission), MTN has imposed time restrictions for promotional SMS termination. Promotional messages are restricted between 8 PM to 8 AM.\r\n\r\nIn order to comply with the above regulations, messages sent during the mentioned window will be queued and submitted to the operator for delivery after 8 AM.\r\n\r\nPlease note that this does not affect OTP and other transactional messages that are pre-approved to send through API."),
            ],
          ),
          SizedBox(
            height: screenHeight(context) * 0.03,
          ),
          const Divider(),
          ListBody(
            children: [
              Text(
                "Message Testing Before Sending Bulk",
                style: TextStyle(fontWeight: fnt600),
              ),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              const Text(
                  "Please TEST your message to one or two numbers before sending it to BULK numbers.\r\n\r\nThis is important because network providers have the explicit right to block any content or sender at their discretion without refund.\r\n\r\nPlease note that this does not affect API users who are sending pre-approved OTP and other transactional messages.However, if you are having a delivery issue with your message, contact us and we shall be more than happy to assist.\r\n\r\nThank you so much for your kind patronage and understanding."),
            ],
          ),
        ],
      ),
    );
  }
}
