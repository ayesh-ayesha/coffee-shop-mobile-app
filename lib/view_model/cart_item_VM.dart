import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/cartItem.dart';
import 'package:layouts_flutter/repos/cartItem_repo.dart';
import 'package:layouts_flutter/view_model/place_order_vm.dart';

import '../models/coffee_item.dart';
import 'UserProfile_vm.dart';
import 'app_Indicators_vm.dart';

class CartItemVM extends GetxController {
  late CartItemRepo cartItemRepo;
  late UserProfileVM userProfileVM;
  AppIndicatorsVM appIndicatorsVM = Get.find();


  // sending data to database
  var userSelectedBeanType = ''.obs;
  var userSelectedMilkType = ''.obs;
  var sizeOfCoffee = ''.obs;

  var priceSize = 0.0.obs;

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    cartItemRepo = Get.find();
    userProfileVM = Get.find();
    ever(cartItems, (_) {
      appIndicatorsVM.cartItemCount.value = cartItems.length;
    });

    loadAllCartItems();
  }

  bool exists(item) {
    return cartItems.any(
      (element) =>
          element.coffeeItemId == item.id &&
          element.selectedBeanType == userSelectedBeanType.value &&
          element.selectedMilkType == userSelectedMilkType.value &&
          element.selectedSize == sizeOfCoffee.value,
    );
  }

  CartItem? getCartItem(CoffeeItem item) {
    try {
      return cartItems.firstWhere(
        (element) =>
            element.coffeeItemId == item.id &&
            element.selectedBeanType == userSelectedBeanType.value &&
            element.selectedMilkType == userSelectedMilkType.value &&
            element.selectedSize == sizeOfCoffee.value,
      );
    } catch (_) {
      return null;
    }
  }



  Future<void> addToCart(item) async {
    if (userSelectedBeanType.value.isEmpty) {
      Get.snackbar('Error', 'Please select bean type',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    if (userSelectedMilkType.value.isEmpty) {
      Get.snackbar('Error', 'Please select milk type',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    if (sizeOfCoffee.value.isEmpty) {
      Get.snackbar('Error', 'Please select size',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    if (exists(item)) {
      Get.snackbar('Error', 'Item already exists in cart',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    if (sizeOfCoffee.value == 'S') {
      priceSize.value = item.smallPrice;
    } else if (sizeOfCoffee.value == 'M') {
      priceSize.value = item.mediumPrice;
    } else if (sizeOfCoffee.value == 'L') {
      priceSize.value = item.largePrice;
    }

    try {
      // 1. Create the new item
      CartItem newCartItem = CartItem(
        id: '',
        coffeeItemId: item.id,
        quantity: 1,
        unitPrice: priceSize.value,
        totalPrice: priceSize.value,
        selectedBeanType: userSelectedBeanType.value,
        selectedMilkType: userSelectedMilkType.value,
        coffeeItemName: item.name,
        coffeeItemImage: item.image,
        selectedSize: sizeOfCoffee.value,
        userName: userProfileVM.selectedUser.value?.displayName ?? '',
        userId: userProfileVM.currentUserId,
      );

      // 3. Add item
      await cartItemRepo.addCartItem(newCartItem);
      Get.snackbar('Success', 'Item added to cart',colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
    } catch (e) {
      Get.snackbar('Error', e.toString(),colorText: Colors.white,backgroundColor: Colors.red);
    }
  }

  void loadAllCartItems() {
    if(userProfileVM.currentUserId.isEmpty)return;
// TODO: IMPLEMENT THE ID OF THE USER
    cartItemRepo.loadCurrentUserCartItems().listen((data) {
      cartItems.value = data;
    });
  }

  Future<void> deleteCartItem(CartItem cartItem) async {
    try {
      await cartItemRepo.deleteCartItem(cartItem);
      Get.snackbar("Success", "Item deleted successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> updateCartItem(CartItem cartItem, String action) async {
    if (action == 'add' && cartItem.quantity < 10) {
      cartItem.quantity++;
    } else if (action == 'remove' && cartItem.quantity > 1) {
      cartItem.quantity--;
    }
    int newQuantity = cartItem.quantity;

    // Update total price based on unit price
    cartItem.totalPrice = cartItem.unitPrice * cartItem.quantity;
    try {
      await cartItemRepo.updateCartItemFields(
        cartItem.id,
        newQuantity: newQuantity,
        newTotalPrice: cartItem.totalPrice,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    // Trigger update
    cartItems.refresh();
  }

  void resetSelections() {
    userSelectedBeanType.value = '';
    userSelectedMilkType.value = '';
    sizeOfCoffee.value = '';
    print("Selections reset for new item."); // For debugging
  }

  void placeOrderScreen() {
    Get.toNamed('/check_out_page');
  }

  void triggerPlaceOrderVMUpdate() {
    // You can find it safely here, as this method is called *after* onInit
    // and only when an action requires it.
    try {
      final placeOrderController = Get.find<PlaceOrderVM>();
      // Now you can call methods or update properties on placeOrderController
      placeOrderController
          .calculatePrice(); // A method you'd add to PlaceOrderVM
    } catch (e) {
      print('PlaceOrderVM not found when trying to update: $e');
    }
  }

  double priceInCart() {
    double cartItemsPrice = 0.00;
    for (var item in cartItems) {
      cartItemsPrice += item.totalPrice;
    }
    return cartItemsPrice;
  }
}
