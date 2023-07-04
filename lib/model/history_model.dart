class History {
  final String amount;
  final String reference;
  final String date;

  const History({
    required this.amount,
    required this.reference,
    required this.date,
  });
  factory History.fromJson(Map<String, dynamic> jsonData) {
    return History(
        amount: jsonData['amount'],
        reference: jsonData['reference'],
        date: jsonData['date']);
  }
}
