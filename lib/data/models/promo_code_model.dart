class PromoCodeModel {
  final String code;
  final double value;
  final bool isPercentage;

  PromoCodeModel({
    required this.code,
    required this.value,
    required this.isPercentage,
  });

  // Mock Data for testing
  // TODO: (Later fetch from firestore)

  static List<PromoCodeModel> get mockCodes => [
    PromoCodeModel(code: "WELCOME", value: 10, isPercentage: true),
    PromoCodeModel(code: "DRIPS20", value: 20, isPercentage: false),
  ];
}
