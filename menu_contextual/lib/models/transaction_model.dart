class TransactionModel {
  final String id;
  final String paymentId;
  final String userId;
  final double amount;
  final String status;
  final String date;

  TransactionModel({
    required this.id,
    required this.paymentId,
    required this.userId,
    required this.amount,
    required this.status,
    required this.date,
  });

  // Convertir de JSON a modelo
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? '',
      paymentId: json['paymentId'] ?? '',
      userId: json['userId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      date: json['date'] ?? '',
    );
  }

  // Convertir de modelo a JSON
  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'userId': userId,
      'amount': amount,
      'status': status,
      'date': date,
    };
  }
}
