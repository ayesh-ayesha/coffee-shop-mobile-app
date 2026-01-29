import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/orderItem.dart';
import 'package:layouts_flutter/repos/cartItem_repo.dart';
import 'package:layouts_flutter/repos/payment_repo.dart';
import 'package:layouts_flutter/repos/place_order_repo.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';
import 'package:layouts_flutter/view_model/cart_item_VM.dart';
import 'package:layouts_flutter/view_model/paymentVm.dart';

import 'app_Indicators_vm.dart';
import 'bottom_nav_bar_vm.dart';

class PlaceOrderVM extends GetxController {
  late PlaceOrderRepo placeOrderRepo;
  late UserProfileVM userProfileVM;
  late CartItemVM cartItemVM;
  late CartItemRepo cartItemRepo;
  late PaymentRepo paymentRepo;
  late PaymentVM paymentVM;
  final AppIndicatorsVM appIndicatorsVM = Get.find();
  RxDouble total = 0.00.obs;



  @override
  void onInit() {
    super.onInit();
    cartItemVM = Get.find();
    placeOrderRepo = Get.find();
    userProfileVM = Get.find();
    cartItemRepo = Get.find();
    paymentRepo = Get.find();
    paymentVM = Get.find();

    ever(cartItemVM.cartItems, (_) => calculatePrice());
    loadAllOrderItems();
    ever(orderItemsList, (_) {
      appIndicatorsVM.orderItemCount.value = orderItemsList.length;
    });

    loadOrdersOfCurrentUser();
    calculatePrice();
  }



  final TextEditingController specialInstructionsController = TextEditingController();
  final TextEditingController searchUserController = TextEditingController();
  final TextEditingController searchAdminController = TextEditingController();
  @override
  void onClose() {
    specialInstructionsController.dispose();
    super.onClose();
  }

  var shippingFee = 7.50.obs;

  get subtotal => cartItemVM.priceInCart();
  var taxes = 0.08.obs;
  var orderStatus = 'pending'.obs;

  var orderItemsList = <OrderItem>[].obs;
  var currentUserOrders = <OrderItem>[].obs;
  var userSearchedItems=<OrderItem>[].obs;
  var adminSearchedItems=<OrderItem>[].obs;

  var shippingMethod = "Standard Shipping 45-60 minutes".obs;

  List<Map<String, dynamic>> get cartItemsAsMapList {
    return cartItemVM.cartItems.map((item) => {
      'name': item.coffeeItemName,
      'image': item.coffeeItemImage,
      'price': item.totalPrice,
      'quantity': item.quantity,
      'beanType': item.selectedBeanType,
      'selectedMilkType': item.selectedMilkType,
      'selectedSize': item.selectedSize,
      'userId': item.userId,
    }).toList();
  }

  void searchUserOrderItem(String query) {
    if (query.trim().isEmpty) {
      // When the search query is empty, the `currentUserOrders` should be restored to the full list.
      // However, calling `loadOrdersOfCurrentUser()` will re-fetch from the database, which is
      // inefficient and can cause UI flickering.
      // The correct approach is to save the original list and filter from that.
      // For now, let's just make sure to not filter when the query is empty.
      // The UI should display `currentUserOrders` when `searchedItems` is empty.
      userSearchedItems.value = []; // Clear the searched items to show the full list
      return;
    }

    final q = query.toLowerCase();

    final filtered = currentUserOrders.where((order) {
      // Check fields in order itself
      final status = order.orderStatus.toLowerCase();
      final id = order.id.toLowerCase();

      final isPaid = order.paymentStatus.toLowerCase(); // Ensure this is also lowercase
      final totalProducts = order.totalProducts.toString(); // Ensure this is also lowercase
      final price = order.totalAmount.toString() ;

      // Check items inside order
      final matchesItem = order.items.any((item) {
        final name = item['name']?.toString().toLowerCase() ?? '';
        final milkType = item['selectedMilkType']?.toString().toLowerCase() ?? '';
        final beanType = item['beanType']?.toString().toLowerCase() ?? '';

        return name.contains(q) ||
            milkType.contains(q) ||
            beanType.contains(q);
      });

      // Match order-level or item-level fields
      return status.contains(q) || id.contains(q)||isPaid.contains(q) || matchesItem|| totalProducts.contains(q) || price.contains(q);
    }).toList();

    userSearchedItems.value = filtered; // Update the searchedItems list, not currentUserOrders
  }
  void searchAdminOrderItem(String query) {
    if (query.trim().isEmpty) {
      adminSearchedItems.value = [];
      return;
    }
    final q = query.toLowerCase();
    final filtered = orderItemsList.where((order) {
      // Combine all order-level search fields into a single string.
      final orderInfo = [
        order.userName,
        order.id,
        order.orderStatus,
        order.paymentMethod,
        order.deliveryMode,
        // Format the date for a more natural search (e.g., '2023-10-25')
        '${order.orderDate.year}-${order.orderDate.month}-${order.orderDate.day}',
        order.paymentStatus,
        order.totalProducts.toString(),
        order.totalAmount.toString(),
      ].map((s) => s.toLowerCase()).join(' ');

      // Check if any of the order-level information contains the query.
      bool orderMatch = orderInfo.contains(q);

      // Check if any of the item-level information contains the query.
      bool itemMatch = order.items.any((item) {
        final itemName = item['name']?.toString().toLowerCase() ?? '';
        final milkType = item['selectedMilkType']?.toString().toLowerCase() ?? '';
        final beanType = item['beanType']?.toString().toLowerCase() ?? '';
        // You can add more item fields here if needed.

        return itemName.contains(q) || milkType.contains(q) || beanType.contains(q);
      });

      // The order is a match if either the order-level info or the item-level info matches.
      return orderMatch || itemMatch;
    }).toList();

    adminSearchedItems.value = filtered;
  }
  Map<String, dynamic> get getAddress {
    return {
      'address': userProfileVM.selectedUser.value?.address ?? '',
      'city': userProfileVM.selectedUser.value?.city ?? '',
      'country': userProfileVM.selectedUser.value?.country ?? '',
      'phoneNumber': userProfileVM.selectedUser.value?.phoneNumber ?? '',
    };
  }

  Future<void> placeOrder() async {
    if (userProfileVM.address.isEmpty) {
      Get.snackbar("Error", "Please add your address");
      return;
    }

    String paymentStatus = 'Pending';

    // Step 1: Handle online payment if selected.
    if (paymentVM.selectedPaymentMethod.value == 'Online Payment') {
      try {
        // Await the payment process. This will block execution until
        // the user either completes the payment or cancels it.
        await paymentVM.makePayment(total.toStringAsFixed(2));

        // After the payment sheet is closed, check the isPaid flag.
        if (paymentVM.isPaid.value) {
          paymentStatus = 'Paid';
        } else {
          // If the payment was not successful, we should not proceed with the order.
          // The user can try again or select a different payment method.
          Get.snackbar(
            "Payment Unsuccessful",
            "Please complete your payment to place the order.",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return; // Exit the function
        }
      } catch (e) {
        // Catch any unexpected errors from the payment process.
        Get.snackbar("Error", "An unexpected error occurred during payment.");
        return; // Exit the function
      }
    }

    // Step 2: Create the OrderItem with the determined payment status.
    try {
      OrderItem addOrderItem = OrderItem(
        id: '',
        userId: userProfileVM.getCurrentUserId,
        userName: userProfileVM.selectedUser.value!.displayName,
        orderDate: DateTime.now(),
        totalAmount: calculatePrice(),
        items: cartItemsAsMapList,
        deliveryMode: 'Deliver to Home',
        totalProducts: cartItemVM.cartItems.length,
        paymentMethod: paymentVM.selectedPaymentMethod.value,
        paymentStatus: paymentStatus, // Use the status we determined above
        orderStatus: orderStatus.value,
        address: getAddress,
        specialInstructions: specialInstructionsController.text,
      );

      // Step 3: Save the order to the database.
      await placeOrderRepo.addOrderItem(addOrderItem);

      // Step 4: Clear the cart and navigate.
      await cartItemRepo.clearUserCart();

      Get.snackbar("Success", "Order Placed Successfully",backgroundColor: Color(0xFFC67C4E),colorText: Colors.white);
      Get.until((route) => Get.currentRoute == '/bottom_nav_bar');
      Get.toNamed('/home', id: 1);
      Get.find<BottomNavBarVM>().changeTabIndex(0);
    } catch (e) {
      Get.snackbar("Error", "Failed to place order: $e");
    }
  }

  void loadAllOrderItems() {
    placeOrderRepo.loadAllOrderItems().listen((data) {
      orderItemsList.value = data;
    });
  }

  void loadOrdersOfCurrentUser() {
    placeOrderRepo.loadOrdersOfCurrentUser(userProfileVM.getCurrentUserId).listen((data) {
      currentUserOrders.value = data;
    });
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    await placeOrderRepo.updateOrderStatus(orderId, newStatus);
    loadAllOrderItems();
  }

  void updatePaymentStatus(String orderId, String newPaymentStatus) async {
    await placeOrderRepo.updatePaymentStatus(orderId, newPaymentStatus);
    loadAllOrderItems();
  }
  double calculatePrice() {
    double sub = subtotal;
    double taxAmount = sub * taxes.value;
    total.value = sub + shippingFee.value + taxAmount;
    return total.value;
  }

}