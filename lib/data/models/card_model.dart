class CardModel {
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;
  final String cardType;

  const CardModel({
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
  });

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    return "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}";
  }

 // Convert to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'cardNumber': cardNumber,
      'holderName': holderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardType': cardType,
    };
  }

  // from Map (from Firestore)
  factory CardModel.fromMap(Map<String, dynamic> map) {
    return CardModel(
      cardNumber: map['cardNumber'] ?? '',
      holderName: map['holderName'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      cvv: map['cvv'] ?? '',
      cardType: map['cardType'] ?? 'Visa',
    );
  }
}
