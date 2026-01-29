import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:layouts_flutter/repos/auth_repo.dart';
import 'package:layouts_flutter/repos/user_profile_repo.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';


import '../models/orderItem.dart';
import 'notifications_repo.dart';

class PlaceOrderRepo {
  late CollectionReference orderItemCollection;


  PlaceOrderRepo() {
    orderItemCollection = FirebaseFirestore.instance.collection('OrderItem');

  }

  Future<void> addOrderItem(OrderItem orderItem) {
    var doc = orderItemCollection.doc();
    orderItem.id = doc.id;
    return doc.set(orderItem.toMap());
  }


  Future<void> updateOrderItem(OrderItem orderItem) {
    return orderItemCollection.doc(orderItem.id).set(orderItem.toMap());
  }

  Stream<List<OrderItem>> loadAllOrderItems() {
    return orderItemCollection.snapshots().map((snapshot) {
      return convertToOrderItems(snapshot);
    });
  }

  // utility function
  List<OrderItem> convertToOrderItems(QuerySnapshot snapshot) {
    List<OrderItem> products = [];
    for (var snap in snapshot.docs) {
      products.add(OrderItem.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<void> deleteOrderItem(OrderItem orderItem) {
    return orderItemCollection.doc(orderItem.id).delete();
  }

  // Assuming orderItemCollection is already defined (e.g., FirebaseFirestore.instance.collection('orderItems'))

  Future<void> updateOrderItemFields(
      String orderItemId, {
        int? newQuantity,
        double? newTotalPrice,
      }) async {
    Map<String, dynamic> updates = {};

    if (newQuantity != null) {
      updates['quantity'] = newQuantity;
    }
    if (newTotalPrice != null) {
      updates['totalPrice'] = newTotalPrice;
    }


    // Only proceed if there are actual updates to send
    if (updates.isNotEmpty) {
      return orderItemCollection.doc(orderItemId).update(updates);
    } else {
      // Optionally, handle the case where no fields were provided for update
      print('No fields provided to update for cart item: $orderItemId');
      return Future.value(); // Return a completed future
    }
  }

  Future<void> updateOrderStatus(String orderItemId, String newStatus) async {
    await orderItemCollection.doc(orderItemId).update({
      'orderStatus': newStatus,
    });
  }

  Future<void> updatePaymentStatus(String orderItemId, String newPaymentStatus) async {
    await orderItemCollection.doc(orderItemId).update({
      'paymentStatus': newPaymentStatus,
    });
  }

  loadOrdersOfCurrentUser(userId) {
    return orderItemCollection.where('userId', isEqualTo: userId).snapshots().map((snapshot) {
      return convertToOrderItems(snapshot);
    });
  }

}
