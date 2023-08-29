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
import 'package:nbsms/widgets/personal_contact_dropdown_widget.dart';
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
  bool isBulkNumberSelected = false;
  bool _isLoggingIn = false;
  String selectedBulkNumber = '';
  bool hasShownAlert = false;
  List<String> fetchedBulkNumbers = [];
  List<Map<String, dynamic>> fetchedBulkNumbersWithSelection = [];
  Contactt? selectedContact;
  List<Contactt> personalContacts = [];
  List<Contactt> selectedContacts = [];
  late ScaffoldMessengerState _scaffoldMessengerState;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Timer? _alertTimer;
  final TextEditingController recipientsController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _startAlertTimer();
    _loadSavedBalance();
    _loadPersonalContacts();
    _fetchBulkNumberWithSelection();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scaffoldMessengerState = ScaffoldMessenger.of(context);
  }

  Future<void> _loadPersonalContacts() async {
    List<Contactt> contacts = await fetchAndPrintContacts();

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        personalContacts = contacts;
      });
    }
  }

  @override
  void dispose() {
    _alertTimer?.cancel();
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('hasShownAlert', false);
    }); // Cancel the timer if it's active
    recipientsController.dispose();
    senderNameController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Future<List<Contactt>> fetchAndPrintContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<Contactt> fetchedContacts = await fetchContacts(username, password);
      return fetchedContacts;
    } catch (e) {
      return []; // Return an empty list in case of an error
    }
  }

  Future<List<Map<String, dynamic>>> _fetchBulkNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<Map<String, dynamic>> fetchedBulkNumber =
          await fetchBulkNumber(username, password);

      // Add a selected flag to each item
      List<Map<String, dynamic>> bulkNumbersWithSelection =
          fetchedBulkNumber.map((data) {
        return {
          'name': data['name'] as String,
          'selected': false,
        };
      }).toList();

      return bulkNumbersWithSelection;
    } catch (e) {
      print('Error fetching bulk numbers: $e');
      return []; // Return an empty list or handle the error case as needed
    }
  }

  Future<void> _fetchBulkNumberWithSelection() async {
    List<Map<String, dynamic>> bulkNumbers = await _fetchBulkNumber();
    setState(() {
      fetchedBulkNumbersWithSelection = bulkNumbers;
    });
  }

  // Future<List<String>> _fetchBulkNumber() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String username = prefs.getString('username') ?? '';
  //   String password = prefs.getString('password') ?? '';

  //   try {
  //     List<Map<String, dynamic>> fetchedBulkNumber =
  //         await fetchBulkNumber(username, password);
  //     List<String> names =
  //         fetchedBulkNumber.map((data) => data['name'] as String).toList();
  //     return names;
  //   } catch (e) {
  //     print('Error fetching bulk numbers: $e');
  //     return []; // Return an empty list or handle the error case as needed
  //   }
  // }

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  Future<void> _sendMessage() async {
    setState(() {
      _isLoggingIn = true;
    });

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

        // Check for insufficient funds
        if (newBalance < 3) {
          _scaffoldMessengerState.showSnackBar(
            const SnackBar(
              content: Text('Insufficient funds'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          setState(() {
            balance = '$newBalance';
          });

          prefs.setString('balance', '$newBalance');

          recipientsController.clear();
          senderNameController.clear();
          messageController.clear();

          showDialog(
            context: _scaffoldKey.currentContext!,
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
        }
      } else {
        showDialog(
          context: _scaffoldKey.currentContext!,
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
        context: _scaffoldKey.currentContext!,
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
    } finally {
      setState(() {
        _isLoggingIn = false;
      });
    }
  }

  Future<void> _fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    String fetchedBalance = await fetchBalance(username, password);

    prefs.setString('balance', fetchedBalance); // Save the fetched balance

    if (mounted) {
      setState(() {
        balance = fetchedBalance;
      });
    }
  }

  void _startAlertTimer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownAlert = prefs.getBool('hasShownAlert') ?? false;

    if (!hasShownAlert) {
      _alertTimer = Timer(const Duration(seconds: 1), () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            title: const Text(
              'Dear valued customer',
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Please TEST your message to one or two numbers before sending it to BULK numbers. This is important because network providers have the explicit right to block any content or sender at their discretion without refund.\r\n\r\nPlease note that this does not affect API users who are sending pre-approved transactional messages.\r\n\r\nHowever, if you are having a delivery issue with your message, contact us and we shall be more than happy to assist.\r\n\r\nThank you so much for your kind patronage and understanding.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    hasShownAlert = true;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        );
        prefs.setBool('hasShownAlert', true);
      });
    }
  }

  // Initial Selected Value
  String dropdownvalue = 'New Contacts';

  // List of items in our dropdown menu
  var items = [
    'New Contacts',
    'Personal Contacts',
    'Device Contacts',
    'Bulk Numbers'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: Form(
            key: _formKey,
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
                  onChanged: (String? newValue) async {
                    if (newValue != 'Bulk Numbers') {
                      setState(() {
                        selectedBulkNumber = '';
                      });
                    }
                    List<String> bulkNumbers = [];

                    if (newValue == 'Bulk Numbers') {
                      bulkNumbers = (await _fetchBulkNumber()).cast<String>();
                    }

                    setState(() {
                      dropdownvalue = newValue!;
                      isBulkNumberSelected = newValue == 'Bulk Numbers';
                      fetchedBulkNumbers = bulkNumbers;
                      if (newValue == 'Personal Contacts') {
                        selectedContact = null;
                      } else if (newValue != 'Bulk Numbers') {
                        recipientsController.clear();
                      }
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
                if (dropdownvalue == 'New Contacts')
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                if (dropdownvalue == 'Device Contacts')
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                if (dropdownvalue == 'Bulk Numbers') ...[
                  SizedBox(
                    height: screenHeight(context) * 0.03,
                  ),
                  if (fetchedBulkNumbersWithSelection.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fetched Bulk Numbers:',
                          style: TextStyle(
                            color: const Color.fromARGB(176, 0, 141, 5),
                            fontFamily: roboto,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (int index = 0;
                            index < fetchedBulkNumbersWithSelection.length;
                            index++)
                          Row(
                            children: [
                              Checkbox(
                                value: fetchedBulkNumbersWithSelection[index]
                                    ['selected'],
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    for (int i = 0;
                                        i <
                                            fetchedBulkNumbersWithSelection
                                                .length;
                                        i++) {
                                      fetchedBulkNumbersWithSelection[i]
                                          ['selected'] = false;
                                    }
                                    fetchedBulkNumbersWithSelection[index]
                                        ['selected'] = newValue!;
                                  });
                                },
                              ),
                              Text(
                                fetchedBulkNumbersWithSelection[index]['name']
                                    as String,
                                style: TextStyle(
                                  fontFamily: roboto,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  if (fetchedBulkNumbersWithSelection.isEmpty)
                    Text(
                      'No bulk numbers available',
                      style: TextStyle(
                        color: const Color.fromARGB(176, 0, 141, 5),
                        fontFamily: roboto,
                      ),
                    ),
                ],

                // if (dropdownvalue == 'Bulk Numbers') ...[
                //   SizedBox(
                //     height: screenHeight(context) * 0.03,
                //   ),
                //   if (fetchedBulkNumbers.isNotEmpty)
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Text(
                //           'Fetched Bulk Numbers:',
                //           style: TextStyle(
                //             color: const Color.fromARGB(176, 0, 141, 5),
                //             fontFamily: roboto,
                //           ),
                //         ),
                //         const SizedBox(height: 8),
                //         for (String number in fetchedBulkNumbers)
                //           Text(
                //             number,
                //             style: TextStyle(
                //               fontFamily: roboto,
                //               fontSize: 14,
                //             ),
                //           ),
                //       ],
                //     ),
                //   if (fetchedBulkNumbers.isEmpty)
                //     Text(
                //       'No bulk numbers available',
                //       style: TextStyle(
                //         color: const Color.fromARGB(176, 0, 141, 5),
                //         fontFamily: roboto,
                //       ),
                //     ),
                // ],
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (dropdownvalue == 'Personal Contacts')
                    personalContacts.isEmpty
                        ? Text(
                            'No personal contacts saved',
                            style: TextStyle(
                                color: const Color.fromARGB(176, 0, 141, 5),
                                fontFamily: roboto),
                          )
                        : PersonalContactsDropdown(
                            personalContacts: personalContacts,
                            selectedContacts: selectedContacts,
                            onChanged: (List<Contactt> newSelectedContacts) {
                              setState(() {
                                selectedContacts = newSelectedContacts;
                              });
                              final mobileNumbers = selectedContacts
                                  .map((contact) => contact.mobile)
                                  .join(' ');
                              recipientsController.text = mobileNumbers;
                            },
                          ),
                ]),
                const SizedBox(
                  height: 10,
                ),
                if (!isBulkNumberSelected) // Conditionally include TextFormField
                  TextFormField(
                    controller: recipientsController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Separate each phone number with a space",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.greenAccent,
                        ),
                      ),
                      labelText: "Recipients",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your recipient number';
                      }
                      return null;
                    },
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your sender name';
                      }
                      return null;
                    }),
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
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your message';
                      }
                      return null;
                    }),
                SizedBox(
                  height: screenHeight(context) * 0.04,
                ),
                SubmitButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _sendMessage();
                    }
                  },
                  text: _isLoggingIn ? '' : 'Send Message',
                  bgcolor: nbPrimarycolor,
                  fgcolor: nbSecondarycolor,
                  width: screenWidth(context) * 0.95,
                  textStyle: TextStyle(fontWeight: fnt500, fontSize: 16.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Visibility(
                        visible: _isLoggingIn,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.0,
                          backgroundColor:
                              Colors.grey, // Set the background color
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      Visibility(
                        visible: !_isLoggingIn,
                        child: Text(
                          'Send Message',
                          style: TextStyle(
                            color: nbSecondarycolor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight(context) * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
