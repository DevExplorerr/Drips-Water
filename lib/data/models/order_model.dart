import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final AddressModel address;
  final String paymentMethod;
  final String deliveryOption;
  final DateTime? scheduledTime;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double totalAmount;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.address,
    required this.paymentMethod,
    required this.deliveryOption,
    this.scheduledTime,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'cartItems': items.map((x) => x.toMap()).toList(),
      'address': address.toMap(),
      'paymentMethod': paymentMethod,
      'deliveryOption': deliveryOption,
      'scheduleTime': scheduledTime != null
          ? Timestamp.fromDate(scheduledTime!)
          : null,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items:
          (map['cartItems'] as List<dynamic>?)
              ?.map((x) => CartItemModel.fromMap(x as Map<String, dynamic>))
              .toList() ??
          [],
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      paymentMethod: map['paymentMethod'] ?? '',
      deliveryOption: map['deliveryOption'] ?? '',
      scheduledTime: map['scheduleTime'] != null
          ? (map['scheduleTime'] as Timestamp).toDate()
          : null,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (map['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
