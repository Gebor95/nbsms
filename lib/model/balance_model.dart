class Message {
  final String balance;
  final String currency;
  final String symbol;
  final String country;

  const Message({
    required this.balance,
    required this.currency,
    required this.symbol,
    required this.country,
  });

  factory Message.fromJson(Map<String, dynamic> jsonData) {
    return Message(
        balance: jsonData['balance'],
        currency: jsonData['currency'],
        symbol: jsonData['symbol'],
        country: jsonData['country']);
  }
}
