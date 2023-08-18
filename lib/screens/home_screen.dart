import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String balance = " Loading";
  Timer? _alertTimer;
  final TextEditingController recipientsController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _startAlertTimer();
  }

  @override
  void dispose() {
    _alertTimer?.cancel(); // Cancel the timer if it's active
    recipientsController.dispose();
    senderNameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
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

        setState(() {
          balance = '$newBalance';
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Message Sent'),
            content: Text(
                'Status: $status\nCount: $count\nPrice: $price\nBalance Deducted: ₦$messageCost'),
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

  Future<void> _fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    String fetchedBalance = await fetchBalance(
        username, password); // Call the method from api_service.dart
    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        balance =
            fetchedBalance; // Update the balance variable with the fetched value
      });
    }
  }

  void _startAlertTimer() {
    _alertTimer = Timer(const Duration(seconds: 1), () {
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

  Future<void> _pickDeviceContacts() async {
    try {
      final Iterable<Contact> contacts = await ContactsService.getContacts();

      final List<String> phoneNumbers = contacts
          .where((contact) => contact.phones?.isNotEmpty == true)
          .map((contact) => contact.phones!.first.value!)
          .toList();

      setState(() {
        recipientsController.text = phoneNumbers.join(' ');
      });
    } catch (e) {
      print('Error picking device contacts: $e');
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
                  if (newValue == 'Device Contacts') {
                    _pickDeviceContacts();
                  }
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
                controller: recipientsController,
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
                // String recipients = ...; // Get recipients from TextFormField
                // String senderName = ...; // Get sender name from TextFormField
                // String message = ...;    // Get message from TextFormField

                // _sendMessage(recipients, senderName, message);

                // goToReplace(context, const HomeScreen());

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
