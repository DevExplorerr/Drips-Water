class CardModel {
  final String cardNumber;
  final String holderName;
  final String expiryDate;
  final String cvv;

  CardModel({
    required this.cardNumber,
    required this.holderName,
    required this.expiryDate,
    required this.cvv,
  });

  String get maskedNumber {
    if (cardNumber.length < 4) return cardNumber;
    return "**** **** **** ${cardNumber.substring(cardNumber.length - 4)}";
  }
}