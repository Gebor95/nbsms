import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_mediaquery.dart';

class PersonalContWidget extends StatefulWidget {
  const PersonalContWidget({super.key});

  @override
  State<PersonalContWidget> createState() => _PersonalContWidgetState();
}

class _PersonalContWidgetState extends State<PersonalContWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      child: ListView.builder(
        itemCount: 14,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth(context) * 0.01,
                    vertical: screenHeight(context) * 0.01),
                leading: CircleAvatar(
                  backgroundColor: nbPrimarycolor,
                  child: Icon(
                    Icons.person,
                    color: nbSecondarycolor,
                  ),
                ),
                title: const Text("Name Of Contact"),
                subtitle: const Text("0709695049485"),
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.chat,
                      color: nbPrimarycolor,
                    )),
              ),
            ],
          );
        },
      ),
    );
  }
}
