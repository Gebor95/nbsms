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
  @override
  void initState() {
    super.initState();
  }

  String _getInitials(String name) {
    List<String> names = name.split(' ');
    if (names.length > 1) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else if (names.length == 1) {
      return names[0][0].toUpperCase();
    }
    return '?';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      child: FutureBuilder<List<Contactt>>(
        future: fetchAndPrintContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final contacts = snapshot.data!;
            if (contacts.isEmpty) {
              return Container(
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight(context) * 0.10),
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
                    SizedBox(height: screenHeight(context) * 0.03),
                    const Center(
                      child: Text(
                        "No Saved Contact Yet!",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: nbPrimarycolor,
                      child: Text(
                        _getInitials(contact.name),
                        style: TextStyle(
                          color: nbSecondarycolor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(contact.name),
                    subtitle: Text(contact.mobile),
                    trailing: IconButton(
                      onPressed: () {
                        goToPush(context, SendMessage(contact: contact));
                      },
                      icon: Icon(
                        Icons.chat,
                        color: nbPrimarycolor,
                      ),
                    ),
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
    );
  }
}
