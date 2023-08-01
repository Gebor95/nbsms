import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nbsms/model/message_model.dart';

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

Future<List<Map<String, dynamic>>> fetchReports(
    String username, String password) async {
  var url = Uri.parse("https://portal.fastsmsnigeria.com/api/");

  var data = {
    "username": username,
    "password": password,
    "action": "reports",
  };

  final response = await http.post(url, body: data);

  if (response.statusCode == 200) {
    List<dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    return responseData.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Failed to fetch reports.");
  }
}

Future<List<MessageDetails>> fetchMessageDetails(
    String username, String password) async {
  // Replace 'YOUR_API_ENDPOINT' with the actual API endpoint that returns the message history data.
  var url = Uri.parse("https://portal.fastsmsnigeria.com/api/");
  var data = {
    "username": username,
    "password": password,
    "action": "history",
  };

  final response = await http.post(url, body: data);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    print(data);
    return List<MessageDetails>.from(
        data.map((messageJson) => MessageDetails.fromJson(messageJson)));
  } else {
    throw Exception('Failed to fetch message details');
  }
}

Future<List<Map<String, dynamic>>> fetchPayment(
    String username, String password) async {
  var url = Uri.parse("https://portal.fastsmsnigeria.com/api/");

  var data = {
    "username": username,
    "password": password,
    "action": "payments",
  };

  final response = await http.post(url, body: data);

  if (response.statusCode == 200) {
    List<Map<String, dynamic>> responseData =
        List<Map<String, dynamic>>.from(json.decode(response.body));
    //List<dynamic> responseData = jsonDecode(response.body);
    print(responseData);
    return responseData.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Failed to fetch payments.");
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
