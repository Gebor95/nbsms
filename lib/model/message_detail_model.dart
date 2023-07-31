class MessageDetails {
  final String sender;
  final int mobile;
  final double price;
  final int units;
  final String length;
  final String sendDate;
  final String createdDate;
  final String message;

  MessageDetails({
    required this.sender,
    required this.mobile,
    required this.price,
    required this.units,
    required this.length,
    required this.sendDate,
    required this.createdDate,
    required this.message,
  });
  factory MessageDetails.fromJson(Map<String, dynamic> json) {
    return MessageDetails(
      sender: json['sender'],
      mobile: json['mobile'],
      price: json['price'].toDouble(),
      units: json['units'],
      length: json['length'],
      sendDate: json['send_date'],
      createdDate: json['created_date'],
      message: json['message'],
    );
  }
}
