class CardModel {
  final String id;
  final String userId;
  final String cardNumber;
  final String cardHolder;
  final String expirationDate;
  final bool isFrozen;

  CardModel({
    required this.id,
    required this.userId,
    required this.cardNumber,
    required this.cardHolder,
    required this.expirationDate,
    required this.isFrozen,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      cardNumber: json['cardNumber'],
      cardHolder: json['cardHolder'],
      expirationDate: json['expirationDate'],
      isFrozen: json['isFrozen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'cardNumber': cardNumber,
      'cardHolder': cardHolder,
      'expirationDate': expirationDate,
      'isFrozen': isFrozen,
    };
  }

  CardModel copyWith({bool? isFrozen}) {
    return CardModel(
      id: id,
      userId: userId,
      cardNumber: cardNumber,
      cardHolder: cardHolder,
      expirationDate: expirationDate,
      isFrozen: isFrozen ?? this.isFrozen,
    );
  }
}
