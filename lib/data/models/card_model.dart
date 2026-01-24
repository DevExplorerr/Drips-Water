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
}
