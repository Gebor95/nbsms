import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nbsms/model/history_model.dart';
import 'package:nbsms/screens/single.dart';

import '../repository/network.dart';

class PaymentHistory extends StatefulWidget {
  const PaymentHistory({super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  Future getPost() async {
    try {
      final response = await ApiNetwork().fetchData("payments");
      //print(response.statusCode);
      List<History> payments = [];
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        //print(body);
        for (var payments in body) {
          payments.add(History.fromJson(payments));
        }
      } else {
        throw Exception("error");
      }
      return payments;
    } on SocketException {
      const snack = SnackBar(
        content: Text("No internet Access"),
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment History"),
      ),
      body: FutureBuilder(
        future: getPost(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async => await getPost(),
              child: HistoryList(
                index: snapshot.data,
              ),
            );
          } else if (snapshot.hasError) {
            const Center(
              child: Text("Could not Load data"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class HistoryList extends StatelessWidget {
  const HistoryList({super.key, required this.index});
  final List<History> index;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: index.length,
      itemBuilder: (context, i) {
        return Column(
          children: [
            ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SinglePostScreen(
                    title: index[i].amount,
                    body: index[i].reference,
                    id: index[i].date,
                  ),
                ),
              ),
              leading: Text(
                index[i].date,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Text(index[i].amount),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
            ),
            const Divider(
              color: Colors.amber,
            )
          ],
        );
      },
    );
  }
}
