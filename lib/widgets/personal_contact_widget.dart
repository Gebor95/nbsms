import 'package:flutter/material.dart';
import 'package:nbsms/api/api_service.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/send_message_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalContWidget extends StatefulWidget {
  const PersonalContWidget({super.key});

  @override
  State<PersonalContWidget> createState() => _PersonalContWidgetState();
}

class _PersonalContWidgetState extends State<PersonalContWidget> {
  List<Map<String, dynamic>> contacts = [];

  @override
  void initState() {
    super.initState();
    //fetchContact();
    fetchAndPrintContacts();
  }

  Future<List<Contact>> fetchAndPrintContacts() async {
    // Update the return type to Future<List<Contact>>
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<Contact> fetchedContacts = await fetchContacts(username, password);
      return fetchedContacts;
    } catch (e) {
      print("Error fetching contacts: $e");
      return []; // Return an empty list in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      child: FutureBuilder<List<Contact>>(
        future: fetchAndPrintContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final contacts = snapshot.data;
            if (contacts!.isEmpty) {
              return Container(
                clipBehavior: Clip.none,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
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
                        //shape: BoxShape.circle,
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
                        child: Text(" No Saved Contact Yet!",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 25))),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        // title: Text('Contact ID: ${contact.id}'),
                        // contentPadding: EdgeInsets.symmetric(
                        //     horizontal: screenWidth(context) * 0.01,
                        //     vertical: screenHeight(context) * 0.01),
                        leading: CircleAvatar(
                          backgroundColor: nbPrimarycolor,
                          child: Icon(
                            Icons.person,
                            color: nbSecondarycolor,
                          ),
                        ),
                        title: Text(' ${contact.name}'),
                        subtitle: Text(' ${contact.mobile}'),
                        trailing: IconButton(
                          onPressed: () {
                            goToPush(context, const SendMessage());
                          },
                          icon: Icon(
                            Icons.chat,
                            color: nbPrimarycolor,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
      // ListView.builder(
      //   itemCount: contacts.length,
      //   itemBuilder: (context, index) {
      //     final contact = contacts[index];
      //     return Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         ListTile(
      //           contentPadding: EdgeInsets.symmetric(
      //               horizontal: screenWidth(context) * 0.01,
      //               vertical: screenHeight(context) * 0.01),
      //           leading: CircleAvatar(
      //             backgroundColor: nbPrimarycolor,
      //             child: Icon(
      //               Icons.person,
      //               color: nbSecondarycolor,
      //             ),
      //           ),
      //           title: Text(contact['name']),
      //           subtitle: Text(contact['mobile']),
      //           trailing: IconButton(
      //               onPressed: () {
      //                 goToPush(context, const SendMessage());
      //               },
      //               icon: Icon(
      //                 Icons.chat,
      //                 color: nbPrimarycolor,
      //               )),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
