import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/user_model.dart';

class NewProfile extends StatefulWidget {
  const NewProfile({super.key});

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  final TextStyle myStyle = const TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w800,
    color: Colors.blue,
  );
  static const String username = 'ospivvsms@gmail.com';
  static const String password = 'ospivv2018';

  Future getUser() async {
    final response = await http.get(Uri.https(
        "portal.fastsmsnigeria.com/api/?username=$username&password=$password&action=profile"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['status'] == "OK") {
        print(data['status']);
      }
      if (data['error'] != "") {
        print(data['error']);
      }
    } else {
      print(response.body);
    }

    // print(response.body);
    var jsonData = jsonDecode(response.body);
    // print(jsonData);

    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u['name'], u['username'], u['password'], u['email'],
          u['sender'], u['mobile']);
      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
/*       appBar: AppBar(
        centerTitle: true,
        title: const Text("profile"),
      ),

      body: Card(
        child: FutureBuilder(
          future: getUser(),
          builder: ((context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    Text(
                      "Loading...",
                      style: myStyle,
                    )
                  ],
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {},
                    title: Text(snapshot.data[index].name, style: myStyle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.data[index].email),
                        Text(snapshot.data[index].phoneNumber),
                      ],
                    ),
                    trailing: Text(snapshot.data[index].userName),
                  );
                },
              );
            }
          }),
        ),
      ),
      // body: Center(
      //   child: GestureDetector(
      //     onTap: () async => getUser(),
      //     child: Text("No User found", style: myStyle),
      //   ),
      // ),
 */
        );
  }
}
