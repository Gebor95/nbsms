import 'dart:convert';

import 'package:http/http.dart' as http;

import '../screens/message_detail_screen.dart';

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

Future<Map<String, dynamic>> sendMessage(
  String username,
  String password,
  String recipients,
  String senderName,
  String message,
) async {
  const apiUrl = 'https://portal.fastsmsnigeria.com/api/';

  final queryParams = {
    'username': username,
    'password': password,
    'message': message,
    'sender': senderName,
    'mobiles': recipients,
  };

  final response = await http.post(Uri.parse(apiUrl), body: queryParams);

  if (response.statusCode == 200) {
    final responseBody = response.body;
    return parseApiResponse(responseBody);
  } else {
    throw Exception('Failed to send message');
  }
}

Map<String, dynamic> parseApiResponse(String responseBody) {
  final parsed = jsonDecode(responseBody);
  final status = parsed['status'];
  final count = parsed['count'];
  final price = parsed['price'];
  return {'status': status, 'count': count, 'price': price};
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
    var responseData = jsonDecode(response.body);
    print(responseData);
    return responseData.cast<Map<String, dynamic>>();
  } else {
    throw Exception("Failed to fetch payments.");
  }
}

Future<List<Contactt>> fetchContacts(String username, String password) async {
  var data = {
    "username": username,
    "password": password,
    "action": "contacts",
  };

  final response = await http
      .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

  if (response.statusCode == 200) {
    var responseData = jsonDecode(response.body);
    List<Contactt> contacts = List<Contactt>.from(
        responseData.map((contactJson) => Contactt.fromJson(contactJson)));
    return contacts;
  } else {
    throw Exception("Failed to fetch contacts.");
  }
}

class Contactt {
  //int id;
  String name;
  String mobile;

  Contactt({required this.name, required this.mobile});

  factory Contactt.fromJson(Map<String, dynamic> json) {
    return Contactt(
      // id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
    );
  }
}
