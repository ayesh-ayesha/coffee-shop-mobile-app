import 'package:layouts_flutter/models/cartItem.dart';

class OrderItem {
  String id;
  String userId;
  String userName;
  DateTime orderDate;
  double totalAmount;
  List<Map<String, dynamic>> items;
  String deliveryMode;
  int totalProducts;
  String paymentMethod;
  String paymentStatus;
  String orderStatus;
  String specialInstructions;

  Map<String, dynamic> address; // ✅ new field

  OrderItem({
    required this.id,
    required this.userId,
    required this.userName,
    required this.orderDate,
    required this.totalAmount,
    required this.items,
    required this.deliveryMode,
    required this.totalProducts,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.specialInstructions,
    required this.address, // ✅ added here
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'items': items,
      'deliveryMode': deliveryMode,
      'TotalProducts': totalProducts,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'specialInstructions': specialInstructions,
      'address': address, // ✅ added here
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      orderDate: DateTime.parse(map['orderDate']),
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      deliveryMode: map['deliveryMode'] ?? '',
      totalProducts: map['TotalProducts'] ?? 0, // ✅ fixed key
      paymentMethod: map['paymentMethod'] ?? '',
      paymentStatus: map['paymentStatus'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      specialInstructions: map['specialInstructions'] ?? 'no instructions',
      address: Map<String, dynamic>.from(map['address'] ?? {}), // ✅ added here
    );
  }
}
