class PaymentModel {
  final String id;
  final String userId;
  final double amount;
  final String type;
  final String date;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.date,
  });

  // Convertir JSON a objeto
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'],
      userId: json['userId'],
      amount: (json['amount'] as num).toDouble(),
      type: json['type'],
      date: json['date'],
    );
  }

  // Convertir objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'type': type,
      'date': date,
    };
  }
}
