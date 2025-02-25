// Modelo de Tarjeta
class CardModel {
  final int id;
  final int userId;
  final String cardNumber;
  final bool isFrozen;
  final String expirationDate;
  final String cardType;

  CardModel({required this.id, required this.userId, required this.cardNumber, required this.isFrozen, required this.expirationDate, required this.cardType});

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'],
      userId: json['userId'],
      cardNumber: json['cardNumber'],
      isFrozen: json['isFrozen'],
      expirationDate: json['expirationDate'],
      cardType: json['cardType'],
    );
  }
}