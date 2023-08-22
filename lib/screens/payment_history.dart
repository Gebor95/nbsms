import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nbsms/api/api_service.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant_colors.dart';
import '../constant/constant_fonts.dart';
import '../constant/constant_mediaquery.dart';
import '../navigators/goto_helper.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  String balance = " Loading";
  List<Map<String, dynamic>> history = [];
  bool paymentFetched = false;
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadSavedBalance();
    fetchPaymentHistory(selectedStatus);
  }

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  Future<void> fetchPaymentHistory(String selectedStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<Map<String, dynamic>> fetchedPayment =
          await fetchPayment(username, password);

      // Filter the payment history based on the selected status

      if (selectedStatus != 'All') {
        fetchedPayment = fetchedPayment.where((payment) {
          bool isOfflineRecharge = payment['reference'] == null;
          return isOfflineRecharge
              ? selectedStatus == 'Offline'
              : selectedStatus == 'Online';
        }).toList();
      }

      setState(() {
        history = fetchedPayment;
        paymentFetched = true;
      });
    } catch (e) {
      print("Error fetching reports: $e");
      // Handle the error as needed
    }
  }

  final smsCatCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(10),
                    Text(
                      'Payment History',
                      style: TextStyle(
                          fontFamily: roboto,
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Total: ₦$balance",
                      style: TextStyle(
                          fontFamily: roboto,
                          color: Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              const Spacer(),
              Container(
                clipBehavior: Clip.none,
                width: 150,
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
                  hintText: 'All',
                  hintStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                  items: const [
                    'All',
                    'Offline',
                    'Online',
                  ],
                  controller: smsCatCtrl,
                  onChanged: (selectedValue) {
                    setState(() {
                      selectedStatus = selectedValue;
                    });
                    fetchPaymentHistory(selectedStatus);
                  },
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(
            child: paymentFetched
                ? history.isEmpty
                    ? Container(
                        clipBehavior: Clip.none,
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight(context) * 0.10,
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: screenWidth(context) * 0.60,
                              height: screenWidth(context) * 0.60,
                              decoration: BoxDecoration(
                                color: nbPrimarycolor,
                              ),
                              child: Image.asset(
                                'assets/images/messages.jpg',
                                scale: 0.5,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight(context) * 0.03,
                            ),
                            const Center(
                              child: Text(
                                "No Payment History Yet!",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                                trailing: const Icon(
                                  Icons.wallet_rounded,
                                  size: 40,
                                  color: Colors.green,
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(history[index]['date']),
                                    Text(
                                      history[index]['reference'] == null
                                          ? 'OFFLINE RECHARGE'
                                          : 'ONLINE RECHARGE',
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '₦ ${history[index]['amount']}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontFamily: roboto,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )),
                          );
                        },
                      )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    ));
  }
}
