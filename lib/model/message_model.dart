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
