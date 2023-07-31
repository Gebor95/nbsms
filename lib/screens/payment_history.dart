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

  @override
  void initState() {
    super.initState();
    _fetchBalance();
  }

  Future<void> _fetchBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    String fetchedBalance = await fetchBalance(
        username, password); // Call the method from api_service.dart
    setState(() {
      balance = fetchedBalance;
      // Update the balance variable with the fetched value
    });
  }

  // void fetchPayment() async {
  //   //print('fetch payment here');
  //   const String username = 'ospivvsms@gmail.com';
  //   const String password = 'ospivv2018';

  //   const url =
  //       "http://portal.fastsmsnigeria.com/api/?username=$username&password=$password&action=payments";
  //   final uri = Uri.parse(url);
  //   final response = await http.get(uri);
  //   final body = response.body;
  //   final json = jsonDecode(body);
  //   print(json);
  // }

  final List smsPaymentDate = [
    '2023-07-2',
    '2023-04-3',
    '2023-02-22',
    '2023-01-03'
  ];
  final List referenceResponse = [
    'OFFLINE RECHARGE',
    'ONLINE RECHARGE',
    'ONLINE RECHARGE',
    'OFFLINE RECHARGE'
  ];
  final List smsPaymentAmount = ['₦ 31,000', '₦ 1,000', '₦ 310', '₦ 3,100'];

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
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(10),
                    Text(
                      'Payment History',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Total: ₦31,000",
                      style: TextStyle(
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
                ),
              ),
            ],
          ),
          const Gap(20),
          Expanded(
            child: ListView.builder(
              itemCount: smsPaymentAmount.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black26)),
                      trailing: const Icon(
                        Icons.wallet_rounded,
                        size: 40,
                        color: Colors.green,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(smsPaymentDate[index]),
                          Text(
                            referenceResponse[index],
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            smsPaymentAmount[index],
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
