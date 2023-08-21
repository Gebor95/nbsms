import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageDetails {
  final String message;
  final String sender;
  final String price;
  final int units;
  final String length;
  final String sendDate;

  MessageDetails({
    required this.message,
    required this.sender,
    required this.price,
    required this.units,
    required this.length,
    required this.sendDate,
  });

  factory MessageDetails.fromJson(Map<String, dynamic> json) {
    return MessageDetails(
      message: json['message'],
      sender: json['sender'],
      price: json['price'],
      units: json['units'],
      length: json['length'],
      sendDate: json['send_date'],
    );
  }
}

class MessageDetailScreen extends StatefulWidget {
  const MessageDetailScreen({super.key});

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  List<MessageDetails> history = [];

  Future<List<MessageDetails>> fetchMessageDetails(
      String username, String password) async {
    var url = Uri.parse("https://portal.fastsmsnigeria.com/api/");
    var data = {
      "username": username,
      "password": password,
      "action": "history",
    };

    final response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<MessageDetails>.from(
          data.map((messageJson) => MessageDetails.fromJson(messageJson)));
    } else {
      throw Exception('Failed to fetch message details');
    }
  }

  Future<void> fetchAndDisplayReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    try {
      List<MessageDetails> fetchedMessage =
          await fetchMessageDetails(username, password);
      setState(() {
        history = fetchedMessage;
        // Filter the reports based on selected status
      });
    } catch (e) {
      print("Error fetching reports: $e");
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndDisplayReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('07066834706'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Message Details',
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final message = history[index];
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sender: ${message.sender}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Price: ${message.price}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Units: ${message.units}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Length: ${message.length}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Send Date: ${message.sendDate}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Message: ${message.message}',
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
