import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> fetchBalance(String username, String password) async {
  var data = {
    "username": username,
    "password": password,
    "action": "balance", // Use a different action to fetch the balance
  };

  final response = await http
      .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return responseData['balance'].toString();
  } else {
    return "Error fetching balance";
  }
}

Future<String> fetchPaymentHistory(String username, String password) async {
  var data = {
    "username": username,
    "password": password,
    "action": "payments",
  };

  final response = await http
      .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    return responseData['payments'].toString();
  } else {
    return "Error fetching payment history";
  }
}

Future<String> fetchProfile(String username, String password) async {
  var data = {
    "username": username,
    "password": password,
    "action": "profile", // Use a different action to fetch the balance
  };

  final response = await http
      .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    print(responseData);
    return responseData['profile'].toString();
  } else {
    return "Error fetching profile";
  }
}

Future<List<Contact>> fetchContacts(String username, String password) async {
  var data = {
    "username": username,
    "password": password,
    "action": "contacts",
  };

  final response = await http
      .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    List<Contact> contacts = List<Contact>.from(
        responseData.map((contactJson) => Contact.fromJson(contactJson)));
    return contacts;
  } else {
    throw Exception("Failed to fetch contacts.");
  }
}

class Contact {
  //int id;
  String name;
  String mobile;

  Contact({required this.name, required this.mobile});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      // id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}
