import 'package:flutter/material.dart';
import 'package:nbsms/constant/constant_colors.dart';
import 'package:nbsms/constant/constant_fonts.dart';
import 'package:nbsms/navigators/goto_helper.dart';
import 'package:nbsms/screens/notification_screen.dart';
import 'package:nbsms/screens/payment_history.dart';

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

class MessageDetailPersonalScreen extends StatefulWidget {
  final MessageDetails messageDetails;
  final String phoneNumber;
  final String selectedStatus;
  const MessageDetailPersonalScreen(
      {super.key,
      required this.messageDetails,
      required this.phoneNumber,
      required this.selectedStatus});

  @override
  State<MessageDetailPersonalScreen> createState() =>
      _MessageDetailPersonalScreenState();
}

class _MessageDetailPersonalScreenState
    extends State<MessageDetailPersonalScreen> {
  List<MessageDetails> history = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.phoneNumber,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: nbPrimarycolor,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              goToPush(context, const PaymentHistory());
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () {
              goToPush(context, const NotificationScreen());
            },
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
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.selectedStatus),
                      Text(
                        'Sender: ${widget.messageDetails.sender}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Mobile: ${widget.phoneNumber}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Price:₦${widget.messageDetails.price}',
                        style: TextStyle(
                            fontFamily: roboto,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Units: ${widget.messageDetails.units}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Length: ${widget.messageDetails.length}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Send Date: ${widget.messageDetails.sendDate}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Created Date: ${widget.messageDetails.sendDate}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Message: ${widget.messageDetails.message}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
