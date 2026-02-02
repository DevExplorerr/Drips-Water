class PromoCodeModel {
  final String code;
  final double value;
  final bool isPercentage;
  final bool isActive;

  PromoCodeModel({
    required this.code,
    required this.value,
    required this.isPercentage,
    this.isActive = true,
  });

  factory PromoCodeModel.fromMap(Map<String, dynamic> map) {
    return PromoCodeModel(
      code: map['code'] ?? '',
      value: (map['value'] as num?)?.toDouble() ?? 0.0,
      isPercentage: map['isPercentage'] ?? false,
      isActive: map['isActive'] ?? true,
    );
  }
}
