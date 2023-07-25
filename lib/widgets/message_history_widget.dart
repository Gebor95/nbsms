import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/drawer_widget.dart';

import '../constant/constant_colors.dart';
import '../constant/constant_fonts.dart';
import '../constant/constant_mediaquery.dart';
import '../navigators/goto_helper.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key});

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  final List dateAndTime = [
    '2023-07-2',
    '2023-04-3',
    '2023-02-22',
    '2023-01-03'
  ];
  final List status = ['Delivered', 'Submitted', 'Failed', 'DND-ST/1'];
  final List numbers = [
    '07056789975',
    '08056788996',
    '08045742187',
    '07066386545'
  ];

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
              const TextSpan(text: '31,000.00'),
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
            ],
          ),
          const Gap(20),
          Expanded(
            child: ListView.builder(
              itemCount: numbers.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black26)),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 40,
                        color: Colors.black,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateAndTime[index]),
                          Text(
                            status[index],
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            numbers[index],
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
