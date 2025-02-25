

// Modelo de Transacción
class TransactionModel {
  final int id;
  final int userId;
  final double amount;
  final String transactionType;
  final String date;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.transactionType,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount'],
      transactionType: json['transactionType'],
      date: json['date'],
    );
  }
}
