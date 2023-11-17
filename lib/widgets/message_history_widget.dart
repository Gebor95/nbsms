import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nbsms/api/api_service.dart';
import 'package:nbsms/screens/message_detail_screen.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/recharge_screen.dart';
import 'package:nbsms/widgets/drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant_colors.dart';
import '../constant/constant_fonts.dart';
import '../constant/constant_mediaquery.dart';
import '../navigators/goto_helper.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({Key? key}) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  String balance = " Loading";
  bool isLoading = false;
  String selectedPhoneNumber = '';
  List<Map<String, dynamic>> reports = [];
  List<Map<String, dynamic>> filteredReports = [];
  bool reportsFetched = false;
  String selectedStatus =
      'All Status'; // Add this variable to store the selected status

  final Map<String, Color> statusColors = {
    'FAILED': Colors.red,
    'DELIVERED': Colors.green,
    'Submitted': const Color.fromARGB(209, 201, 183, 27),
    'DND-ST/1': Colors.grey,
  };

  final Map<String, IconData> statusIcons = {
    'FAILED': Icons.cancel,
    'DELIVERED': Icons.check_circle,
    'Submitted': Icons.outbox_rounded,
    'DND-ST/1': Icons.lock,
  };

  @override
  void initState() {
    super.initState();
    _loadSavedBalance();
    fetchAndDisplayReports();
  }

  Future<void> _loadSavedBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedBalance = prefs.getString('balance') ?? " Loading";
    setState(() {
      balance = savedBalance;
    });
  }

  Future<void> fetchAndDisplayReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<Map<String, dynamic>> fetchedReports =
          await fetchReports(username, password);
      setState(() {
        reports = fetchedReports;
        filteredReports =
            fetchedReports; // Initialize filteredReports with fetched data
        reportsFetched = true; // Set reportsFetched to true
      });
    } catch (e) {
      // Handle the error as needed
    }
  }

  final smsCatCtrl = TextEditingController();
  void _filterReports(String selectedStatus) async {
    setState(() {
      isLoading = true; // Set isLoading to true when fetching
    });

    setState(() {
      if (selectedStatus.isEmpty) {
        // If no status is selected, show all reports
        filteredReports = reports;
      } else if (selectedStatus == 'Delivered') {
        filteredReports =
            reports.where((report) => report['status'] == 'DELIVERED').toList();
      } else if (selectedStatus == 'Submitted') {
        filteredReports =
            reports.where((report) => report['status'] == 'Submitted').toList();
      } else if (selectedStatus == 'DND') {
        filteredReports =
            reports.where((report) => report['status'] == 'DND-ST/1').toList();
      } else if (selectedStatus == 'Failed') {
        filteredReports =
            reports.where((report) => report['status'] == 'FAILED').toList();
      } else {
        // If an unknown status is selected, show all reports
        filteredReports = reports;
      }
    });
    setState(() {
      isLoading = false;
    });
  }

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
                        fontWeight: FontWeight.w600,
                      ),
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
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: 'All Status',
                      // hintStyle: const TextStyle(
                      //   color: Colors.black,
                      //   fontSize: 20,
                      //   fontWeight: FontWeight.w400,
                      // ),
                      items: const [
                        'All Status',
                        'Delivered',
                        'Submitted',
                        'DND',
                        'Failed',
                      ],
                      controller: smsCatCtrl,

                      // Add onChanged callback to update the selectedStatus
                      onChanged: (newStatus) {
                        setState(() {
                          selectedStatus = newStatus;
                          _filterReports(selectedStatus);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Expanded(
              child: reportsFetched
                  ? reports.isEmpty
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
                                  "No Message Report Yet!",
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
                          itemCount: filteredReports.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> reportData =
                                filteredReports[index];
                            String status = reportData['status'];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  selectedPhoneNumber =
                                      reportData['mobile'].toString();
                                  final String status = reportData['status'];
                                  final Color statusColor =
                                      statusColors[status]!;
                                  final IconData statusIcon =
                                      statusIcons[status]!;
                                  goToPush(
                                    context,
                                    MessageDetailPersonalScreen(
                                      messageDetails:
                                          MessageDetails.fromJson(reportData),
                                      phoneNumber: selectedPhoneNumber,
                                      selectedStatus: status,
                                      selectedStatusColor: statusColor,
                                      selectedStatusIcon: statusIcon,
                                    ),
                                  );
                                },
                                child: ListTile(
                                  shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        const BorderSide(color: Colors.white),
                                  ),
                                  leading: Icon(
                                    statusIcons[status],
                                    color: statusColors[status],
                                    size: 30,
                                  ),
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  title: Text(reportData['send_date']),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        status,
                                        style: TextStyle(
                                          color: statusColors[status],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        reportData['mobile'].toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
