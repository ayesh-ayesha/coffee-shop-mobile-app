import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/coffee_item.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

import '../models/favoriteItem.dart'; // Ensure this path is correct
import '../repos/favorites_repo.dart';
import 'app_Indicators_vm.dart'; // Ensure this path is correct

class FavoriteItemVM extends GetxController {
  FavoritesRepo favoriteItemRepo = Get.find();
  AppIndicatorsVM appIndicatorsVM = Get.find();
  UserProfileVM userProfileVM = Get.find();

  var favoriteItemList = <CoffeeItem>[].obs;
  // REMOVED: var isFavorite = false.obs; // This was problematic as a global state

  @override
  void onInit() {
    super.onInit();
    loadCurrentUserFavoriteItems();
    ever(favoriteItemList, (_) {
      appIndicatorsVM.favoriteItemCount.value = favoriteItemList.length;
    });
  }

  // NOTE: If coffee names are NOT truly unique across your entire product catalog,
  // it's much safer to pass and store the original CoffeeItem's unique ID
  // (e.g., coffeeItemId) within your FavoriteItem model for uniqueness checks.
  // For this example, we'll continue assuming 'name' is unique for simplicity.

  Future<void> addFavoriteItem(CoffeeItem item) async {
    // Check if an item with this name already exists in the favorites list
    bool alreadyExists = favoriteItemList.any((item1) => item1.id == item.id);

    if (alreadyExists) {
      Get.snackbar("Error", "Item already exists in your favorites!");
      return; // IMPORTANT: Stop execution if it already exists
    }

    try {
      FavoriteItem favoriteItem = FavoriteItem(
        id: '',
        productId: item.id,
        createdAt: DateTime.now().toIso8601String(),
        userId: userProfileVM.currentUserId,
        // If you had a coffeeItemId in FavoriteItem, you'd pass it here:
        // coffeeItemId: originalCoffeeItemId,
      );
      await favoriteItemRepo.addFavoriteItem(favoriteItem);
      Get.snackbar("Success", "Item added to favorites",colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
    } catch (e) {
      Get.snackbar("Error", "Failed to add item to favorites: ${e.toString()},colorText: Colors.white,backgroundColor: Colors.red");
    }
  }

  void loadCurrentUserFavoriteItems() {
    // This listener keeps favoriteItemList updated from the backend
    favoriteItemRepo.loadCurrentUserFavoriteItems().listen((data) {
      favoriteItemList.value = data;

    });
  }

  Future<void> deleteFavoriteItem( CoffeeItem item) async {
    try {
      // 1. Find the FavoriteItem object by name from the local list
      // Use firstWhere with orElse to handle cases where the item might not be found


      // 2. Extract the actual 'id' (Firestore document ID) of the FavoriteItem

      // 3. Pass only this unique 'id' to the repository for deletion
      await favoriteItemRepo.deleteFavoriteItemByProductAndUser(coffeeId:item.id, userId:userProfileVM.currentUserId);

      Get.snackbar("Success", "Item removed from favorites");
// favoriteItemList.firstWhere((item)=>item.id==id);
//       await favoriteItemRepo.deleteFavoriteItem(FavoriteItem(id: id, userId: userId, productId: productId, createdAt: createdAt));
    } catch (e) {
      // Catch any errors that occurred during finding the item or the deletion process
      Get.snackbar("Error", "Failed to remove item: ${e.toString()}");
    }
  }

  // This method correctly checks if an item (by its name) is currently in the favorites list.
  bool isItemFavorite(String name) {
    return favoriteItemList.any((item) => item.name == name);
  }
}