class CartItem {
  // TODO: REMOVE REDUNDANT FIELDS
  // TODO: REMOVE userName and id fields

  String id;
  String coffeeItemId;
  String coffeeItemName;
  String coffeeItemImage; // ✅ Optional
  String userId;
  String userName;
  int quantity;
  double unitPrice; // ✅ Optional
  double totalPrice;
  String selectedBeanType;
  String selectedMilkType;
  String selectedSize;// ✅ Optional

  CartItem({
    required this.id,
    required this.coffeeItemId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.selectedBeanType,
    required this.selectedMilkType,
    required this.coffeeItemName,
    required this.coffeeItemImage,
    required this.selectedSize,
    required this.userName,
    required this.userId,
  });

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      coffeeItemId: map['coffeeItemId'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      totalPrice: map['totalPrice'],
      selectedBeanType: map['selectedBeanType'],
      selectedMilkType: map['selectedMilkType'],
      coffeeItemName: map['coffeeItemName'],
      coffeeItemImage: map['coffeeItemImage'],
      selectedSize: map['selectedSize'],
      userName: map['userName'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffeeItemId': coffeeItemId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'selectedBeanType': selectedBeanType,
      'selectedMilkType': selectedMilkType,
      'coffeeItemName': coffeeItemName,
      'coffeeItemImage': coffeeItemImage,
      'selectedSize': selectedSize,
      'userName': userName,
      'userId': userId,
    };
  }
}
