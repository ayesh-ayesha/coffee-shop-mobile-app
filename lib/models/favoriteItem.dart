import 'coffee_item.dart';

class FavoriteItem {
  String id;
  String userId;
  String productId;
  String createdAt;

  FavoriteItem({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  // Convert FavoriteItem to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'createdAt': createdAt,
    };
  }

  // Create FavoriteItem from Map
  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
}
