class AddressModel {
  final String? id;
  final String name;
  final String phone;
  final String region;
  final String city;
  final String district;
  final String address;
  final String? instructions;
  final String? label;
  final bool isDefault;

  AddressModel({
    this.id,
    required this.name,
    required this.phone,
    required this.region,
    required this.city,
    required this.district,
    required this.address,
    this.instructions,
    this.label,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'region': region,
      'city': city,
      'district': district,
      'address': address,
      'instructions': instructions,
      'label': label,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return AddressModel(
      id: docId,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      region: map['region'] ?? '',
      city: map['city'] ?? '',
      district: map['district'] ?? '',
      address: map['address'] ?? '',
      instructions: map['instructions'],
      label: map['label'],
      isDefault: map['isDefault'] ?? false,
    );
  }
}
