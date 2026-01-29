import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/cartItem.dart';

class CartItemRepo {
  final CollectionReference cartItemCollection =
  FirebaseFirestore.instance.collection('cartItems');
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> addCartItem(CartItem cartItem) {
    var doc = cartItemCollection.doc();
    cartItem.id = doc.id;
    return doc.set(cartItem.toMap());
  }

  Future<void> updateCartItem(CartItem cartItem) {
    return cartItemCollection.doc(cartItem.id).set(cartItem.toMap());
  }

  /// ✅ This method now loads only the current user's cart items
  Stream<List<CartItem>> loadCurrentUserCartItems() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint("User not logged in");
      return const Stream.empty(); // Return empty stream if no user
    }

    return cartItemCollection
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) => convertToCartItems(snapshot));
  }

  List<CartItem> convertToCartItems(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => CartItem.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteCartItem(CartItem cartItem) {
    return cartItemCollection.doc(cartItem.id).delete();
  }

  Future<void> clearUserCart() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('Error: User is not logged in. Cannot clear cart.');
      return;
    }

    final userId = user.uid;
    WriteBatch batch = FirebaseFirestore.instance.batch();

    try {
      final querySnapshot = await cartItemCollection
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint('Cart is already empty for user: $userId');
        return;
      }

      for (final doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
      debugPrint('Cart cleared successfully for user: $userId');
    } catch (e) {
      debugPrint('Error clearing cart for user $userId: $e');
      rethrow;
    }
  }

  Future<void> updateCartItemFields(
      String cartItemId, {
        int? newQuantity,
        double? newTotalPrice,
      }) async {
    Map<String, dynamic> updates = {};
    if (newQuantity != null) updates['quantity'] = newQuantity;
    if (newTotalPrice != null) updates['totalPrice'] = newTotalPrice;

    if (updates.isNotEmpty) {
      return cartItemCollection.doc(cartItemId).update(updates);
    } else {
      debugPrint('No fields provided to update for cart item: $cartItemId');
      return Future.value();
    }
  }
}
