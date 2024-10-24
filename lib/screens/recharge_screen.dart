import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/widgets/body_singlescroll_widget.dart';
import 'package:nbsms/widgets/page_title.dart';
import 'package:nbsms/widgets/submit_button.dart';
import 'package:provider/provider.dart'; // Import provider package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/drawer_widget.dart';
import '../model/user.dart'; // Import the UserProfileProvider

class RechargeScreen extends StatefulWidget {
  const RechargeScreen({super.key});

  @override
  State<RechargeScreen> createState() => _RechargeScreenState();
}

class _RechargeScreenState extends State<RechargeScreen> {
  String balance = "Loading";
  String selectedPaymentMethod = 'Online Payment';
  final List<String> paymentMethods = ['Online Payment', 'Bank Transfer'];
  final TextEditingController amountController = TextEditingController();

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? "Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSavedBalance();
  }

// Function to generate a random reference number
  String _generateReference() {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
        32, (index) => characters[random.nextInt(characters.length)]).join();
  }

  Future<void> _processPayment() async {
    final String amount = amountController.text;
    if (amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final userProfile =
        Provider.of<UserProfileProvider>(context, listen: false);
    final String customer =
        userProfile.email ?? 'default@example.com'; // Use the user's email
    const String merchant = '50000204';
    final String reference =
        _generateReference(); // Generate a random reference
    const String narration = 'Bulksms';
    const String redirectUrl = 'http://portal.nigeriabulksms.com/recharge/';
    final String paymentUrl =
        'https://cuepay.com/secure/?pay=invoice&merchant=$merchant&reference=$reference&customer=$customer&narration=$narration&redirect=$redirectUrl&amount=$amount';

    if (await canLaunch(paymentUrl)) {
      await launch(paymentUrl);
    } else {
      throw 'Could not launch $paymentUrl';
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
          overflow: TextOverflow.clip,
          textAlign: TextAlign.end,
          textDirection: TextDirection.rtl,
          softWrap: true,
          maxLines: 1,
          text: TextSpan(
            text: 'Balance: ',
            style: TextStyle(fontFamily: centurygothic, fontSize: 16.0),
            children: <TextSpan>[
              TextSpan(text: '₦', style: TextStyle(fontFamily: roboto)),
              TextSpan(text: balance),
            ],
          ),
          textScaler: const TextScaler.linear(1),
        ),
        actions: [
          IconButton(
            onPressed: () {
              goToPush(context, const RechargeScreen());
            },
            icon: Icon(
              Icons.shopping_cart,
              color: nbSecondarycolor,
            ),
          ),
          IconButton(
            onPressed: () {
              goToPush(context, const NotificationScreen());
            },
            icon: Icon(
              Icons.notifications_active,
              color: nbSecondarycolor,
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: BodyPaddingWidget(
        children: [
          const PageTitle(
            text: "Recharge Account",
          ),
          SizedBox(
            height: screenHeight(context) * 0.06,
          ),
          DropdownButtonFormField<String>(
            value: selectedPaymentMethod,
            items: paymentMethods.map((String method) {
              return DropdownMenuItem<String>(
                value: method,
                child: Text(method),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedPaymentMethod = newValue!;
              });
            },
            decoration: const InputDecoration(
              labelText: "Select Payment Method",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.04,
          ),
          Visibility(
            visible: selectedPaymentMethod == 'Bank Transfer',
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bank Account Name: Interbound Media Managers Ltd",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("First Bank - 2034327658"),
                Text("Zenith Bank - 1015827804"),
                SizedBox(height: 8),
                Text("Call or Whatsapp us after payment: +2348083485142"),
                Text("Or you can send us an email: support@nigeriabulksms.com"),
                SizedBox(height: 8),
                Text("Minimum Payment Allowed: N2,000"),
                SizedBox(height: 15),
                Text(
                  "For Cash Transfer pay into the below account and send our support a message via the WhatsApp customer chat line.",
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight(context) * 0.04,
          ),
          if (selectedPaymentMethod == 'Online Payment')
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "min 2000",
                border: OutlineInputBorder(),
                label: Text("Amount"),
              ),
            ),
          SizedBox(
            height: screenHeight(context) * 0.04,
          ),
          if (selectedPaymentMethod == 'Online Payment')
            SubmitButton(
              onTap: _processPayment,
              text: 'Recharge Account',
              bgcolor: nbPrimarycolor,
              fgcolor: nbSecondarycolor,
              width: screenWidth(context) * 0.95,
              textStyle: TextStyle(fontWeight: fnt500, fontSize: 16.0),
            ),
          SizedBox(
            height: screenHeight(context) * 0.04,
          ),
        ],
      ),
    );
  }
}
