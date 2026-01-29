import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:layouts_flutter/view_model/coffee_milk_type_VM.dart';

import '../models/coffee_item.dart';
import '../repos/coffeeItem_repo.dart';
import '../repos/media_repo.dart';

class CoffeeItemViewModel extends GetxController {
  CoffeeItemRepository coffeeItemRepository = Get.find();
  MediaRepository mediaRepository = Get.find();
  CoffeeMilkTypeVM coffeeMilkTypeVM = Get.find();



  // adding in the database variables
  Rxn<XFile> image = Rxn<XFile>();
  final selectedMilkOptions = <String>[].obs;
  final selectedBeanOptions = <String>[].obs;
  var selectedCategory = 'Espresso'.obs;
  var selectedCategoryInHome = 'All Coffee'.obs;
  var categoriesFilteredItems = <CoffeeItem>[].obs;
  var displayItems = <CoffeeItem>[].obs;
  var coffeeItemList = <CoffeeItem>[].obs;



  void filterCoffeeItemsByCategory(String category) {
    if (category == 'All Coffee') {
      categoriesFilteredItems.value = coffeeItemList;
    } else {
      categoriesFilteredItems.value = coffeeItemList
          .where((item) => item.category == category)
          .toList();
    }
    // Default displayItems to category-filtered list
    displayItems.value = categoriesFilteredItems;
  }



  void searchCoffeeItem(String itemSearch) {
    if (itemSearch.isEmpty) {
      displayItems.value = categoriesFilteredItems;
    } else {
      displayItems.value = categoriesFilteredItems
          .where((item) =>
          item.name.toLowerCase().contains(itemSearch.toLowerCase()))
          .toList();
    }
  }




  final List<String> coffeeCategories = [
    'Espresso',
    'Cappuccino',
    'Latte',
    'Mocha',
    'Americano',
  ];

  TextEditingController searchController=TextEditingController();


  // Change this from Rx<GlobalKey<FormState>> to GlobalKey<FormState>
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // progress variables
  var isSaving = false.obs;
  RxBool availableForDelivery = false.obs;

  // fetching from database variables



  @override
  void onInit() {
    super.onInit();
    loadAllCoffeeItems();
  }

  Future<void> addCoffeeItem(coffeeName, description, smallPrice,mediumPrice,largePrice, longDescription,
      CoffeeItem? coffeeItem) async {


    if (!formKey.currentState!.validate()) return;
    if (image.value == null && (coffeeItem == null || coffeeItem.image.isEmpty)) {
      Get.snackbar('Error', 'Please select an image',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }

    if (selectedMilkOptions.isEmpty) {
      Get.snackbar('Error', 'Please enter milk options for this coffee',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    if (selectedBeanOptions.isEmpty) {
      Get.snackbar('Error', 'Please enter bean options for this coffee',colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }
    try {
      double? parsedPrice( String price)=>double.tryParse(price);
     // this is double?

      if (coffeeItem == null) {
        CoffeeItem addCoffeeItem = CoffeeItem(
          id: '',
          image: '',
          name: coffeeName,
          description: description,
          smallPrice:parsedPrice(smallPrice)??0.0,
          mediumPrice: parsedPrice(mediumPrice)??0.0,
          largePrice: parsedPrice(largePrice)??0.0,
          longDescription: longDescription,
          category: selectedCategory.value,
          beanType: selectedBeanOptions,
          milkType: selectedMilkOptions,
          availableForDelivery: availableForDelivery.value,
        );

        await uploadImage(addCoffeeItem);
        await coffeeItemRepository.addCoffeeItem(addCoffeeItem);

        Get.snackbar("Success", "CoffeeItem added successfully",colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
        // TODO:CREATING PROBLEM WHEN GET.OFFALL IS CALLED
        Get.until((route) => Get.currentRoute == '/bottom_nav_bar');


      } else {
        // Updating existing auction
        if (image.value != null) {
          await uploadImage(coffeeItem);
        }

        CoffeeItem updatedCoffeeItem = CoffeeItem(
            id: coffeeItem.id,
            image: coffeeItem.image,
            name: coffeeName,
            description: description,
            smallPrice:parsedPrice(smallPrice)??0.0,
            mediumPrice: parsedPrice(mediumPrice)??0.0,
            largePrice: parsedPrice(largePrice)??0.0,
            longDescription: longDescription,
            category: selectedCategory.value,
            beanType: selectedBeanOptions,
            milkType: selectedMilkOptions,
            availableForDelivery: availableForDelivery.value,
        );
        await coffeeItemRepository.updateCoffeeItem(updatedCoffeeItem);
        Get.snackbar("Success", "Coffee Item updated successfully",colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
        Get.until((route) => Get.currentRoute == '/bottom_nav_bar');
      }

      // Reset the form values (not the key itself)
      if (coffeeItem == null) {
        image.value = null;
      }
      formKey.currentState?.reset(); // Use reset on the current state
    } catch (e) {
      Get.snackbar("Error", e.toString(),colorText: Colors.white,backgroundColor: Colors.red);
    }
  }


  void loadAllCoffeeItems() {
    coffeeItemRepository.loadAllCoffeeItems().listen((data) {
      coffeeItemList.value = data;

    });
  }

  Future<void> deleteCoffeeItem(CoffeeItem coffeeItem) async {
    try {
      await coffeeItemRepository.deleteCoffeeItem(coffeeItem);
      Get.snackbar("Success", "Item deleted successfully",colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
      Get.until((route) => Get.currentRoute == '/bottom_nav_bar');
    } catch (e) {
      Get.snackbar("Error", e.toString(),colorText: Colors.white,backgroundColor: Colors.red);
    }
  }






  // utility functions
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
  }

  Future<void> uploadImage(CoffeeItem coffeeItem) async {
    if (image.value != null) {
      var imageResult = await mediaRepository.uploadImage(image.value!.path);
      if (imageResult.isSuccessful) {
        coffeeItem.image = imageResult.url!;
      } else {
        Get.snackbar(
          "Error uploading image",
          imageResult.error ?? 'could not upload image due to unknown error',colorText: Colors.white,backgroundColor: Colors.red,
        );
      }
    }
  }







}



