import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/favoriteItem.dart';
import 'package:layouts_flutter/repos/cartItem_repo.dart';
import 'package:layouts_flutter/repos/coffeeItem_repo.dart';
import 'package:layouts_flutter/repos/favorites_repo.dart';
import 'package:layouts_flutter/repos/milk_type_repo.dart';
import 'package:layouts_flutter/view_model/CoffeeItemVM.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';
import 'package:layouts_flutter/view_model/cart_item_VM.dart';
import 'package:readmore/readmore.dart';
import '../models/coffee_item.dart';
import '../repos/coffee_type_repo.dart';
import '../repos/media_repo.dart';
import '../view_model/coffee_milk_type_VM.dart';
import '../view_model/favoriteItem_vm.dart';
import 'custom_widgets.dart'; // IconsOnDetailsPage

class ItemDetailsScreen extends StatefulWidget {
  const ItemDetailsScreen({super.key});

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  late CartItemVM cartItemVm;
  late UserProfileVM userProfileVM;
  late CoffeeItemViewModel coffeeItemViewModel;
  late FavoriteItemVM favoriteItemVM;
  late CoffeeItem item;
  late FavoriteItem favoriteItemId;
  Timer? debounceTimer;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = Get.arguments as CoffeeItem;
    // favoriteItemId= Get.arguments as CoffeeItem.id;
    cartItemVm = Get.find();
    coffeeItemViewModel = Get.find();
    userProfileVM = Get.find();
    favoriteItemVM = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartItemVm.resetSelections();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
// Assuming 'item' is the CoffeeItem object passed to ItemDetailsScreen
// And you have initialized favoriteItemVM: final FavoriteItemVM favoriteItemVM = Get.find();

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Obx(
                    () {
                  // Correctly determine if THIS specific 'item' is favorited
                  // based on the contents of the favoriteItemList
                  final bool isCurrentItemFavorited = favoriteItemVM.isItemFavorite(item.name);

                  return GestureDetector(
                    onTap: () {
                      // If the current item is favorited, then the action should be to DELETE it.
                      if (isCurrentItemFavorited) {
                        favoriteItemVM.deleteFavoriteItem(item);
                      } else {
                        // If the current item is NOT favorited, then the action should be to ADD it.
                        favoriteItemVM.addFavoriteItem(
                         item
                        );
                      }
                    },
                    child: SvgPicture.asset(
                        'assets/icons/heart.svg',
                        height: 24,
                        width: 24,
                        // Use the determined favorite status to set the color
                        colorFilter: isCurrentItemFavorited
                            ? const ColorFilter.mode(Colors.red, BlendMode.srcIn) // Red if favorited
                            : const ColorFilter.mode(Colors.grey, BlendMode.srcIn)  // Grey if not favorited
                    ),
                  );
                }
            ),
          ),
        ],      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.02),

                    // 📸 Image
                    SizedBox(
                      height: screenHeight * 0.3,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(item.image, fit: BoxFit.cover),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    // 📋 Name
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 📝 Description + Icons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.description,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),

                            // available for delivery
                            GestureDetector(
                              onTapDown: (details) {
                                // debounceTimer?.cancel();
                                // debounceTimer=Timer(const Duration(seconds: 1), (){
                                showFloatingMessage(
                                  Get.context!,
                                  details.globalPosition,
                                  item.availableForDelivery
                                      ? "Available for delivery"
                                      : "Not available for delivery",
                                );
                              // });
                              },
                              child: IconsOnDetailsPage(
                                image: 'assets/icons/bike.png',
                                color: item.availableForDelivery
                                    ? const Color(0xFFC67C4E)
                                    : const Color(0xFFEDD6C8),
                              ),
                            ),
                            // Bean Options
                            GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                if (item.beanType.isEmpty) {
                                  Get.snackbar(
                                    'No Options',
                                    'No bean types selected yet.',
                                  );
                                  return;
                                }

                                final position = details.globalPosition;

                                showMenu<String>(
                                  context: context,
                                  color: const Color(0xFFC67C4E),
                                  // Coffee background color
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  position: RelativeRect.fromLTRB(
                                    position.dx - 3,
                                    position.dy,
                                    position.dx - 2,
                                    position.dy,
                                  ),
                                  items: item.beanType.map((e) {
                                    return PopupMenuItem<String>(
                                      value: e,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.coffee,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            e,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ).then((value) {
                                  if (value != null) {
                                    cartItemVm.userSelectedBeanType.value = value;
                                    print('Selected: $value');
                                  }
                                });
                              },
                              child: IconsOnDetailsPage(
                                image: 'assets/icons/beans.png',
                              ),
                            ),

                            // Milk Options
                            GestureDetector(
                              onTapDown: (TapDownDetails details) {
                                if (item.milkType.isEmpty) {
                                  Get.snackbar(
                                    'No Options',
                                    'No milk types selected yet.',
                                      colorText: Colors.white,backgroundColor: Colors.red
                                  );
                                  return;
                                }

                                final position = details.globalPosition;

                                showMenu<String>(
                                  context: context,
                                  color: const Color(0xFFC67C4E),
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  position: RelativeRect.fromLTRB(
                                    position.dx - 3,
                                    position.dy,
                                    position.dx - 3,
                                    position.dy,
                                  ),
                                  items: item.milkType.map((milk) {
                                    return PopupMenuItem<String>(
                                      value: milk,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.local_drink,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            milk,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ).then((value) {
                                  if (value != null) {
                                    cartItemVm.userSelectedMilkType.value = value;
                                    print('Selected milk: $value');
                                  }
                                });
                              },
                              child: IconsOnDetailsPage(
                                image: 'assets/icons/milk.png',
                              ),
                            ),

                          ],
                        ),
                        const SizedBox(height: 5),

                        Row(children: [
                          Spacer(),
                          Text("Choose your perfect flavor combo" ,style:  TextStyle(color: Colors.black),),
                        ],),
                      ],
                    ),





                    const SizedBox(height: 10),

                    // ⭐ Rating
                    Row(
                      children: [
                        RatingWidget(
                          color: Colors.black,
                          fontSize: 20,
                          wSize: 20,
                        ),
                        Text("(230)", style: TextStyle(color: Colors.grey)),
                      ],
                    ),

                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Description",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    ReadMoreText(
                      item.longDescription ?? 'No description available',
                      trimLines: 3,
                      colorClickableText: Color(0xFFC67C4E),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Read more',
                      trimExpandedText: ' Read less',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Size",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Obx(() {
                      String selectedSize = cartItemVm.sizeOfCoffee.value;
                      return Row(
                        children: [
                          SizeOfCoffee(
                            size: "S",
                            isActive: selectedSize == "S",
                            onTap: () => cartItemVm.sizeOfCoffee.value = "S",
                          ),
                          SizeOfCoffee(
                            size: "M",
                            isActive: selectedSize == "M",
                            onTap: () => setState(
                              () => cartItemVm.sizeOfCoffee.value = "M",
                            ),
                          ),
                          SizeOfCoffee(
                            size: "L",
                            isActive: selectedSize == "L",
                            onTap: () => setState(
                              () => cartItemVm.sizeOfCoffee.value = "L",
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),

                    // bean type
                    Text(
                      "Bean Type",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Obx(() {
                      String bean = cartItemVm.userSelectedBeanType.value;
                      return bean.isNotEmpty
                          ? Text(
                              'you Selected ${bean} Bean',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(
                              "please Select bean type from the above available Options",
                              style: TextStyle(color: Colors.grey),
                            );
                    }),
                    const SizedBox(height: 20),

                    // milk type
                    Text(
                      "Milk Type",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Obx(() {
                      String milk = cartItemVm.userSelectedMilkType.value;
                      return milk.isNotEmpty
                          ? Text(
                              'you Selected ${milk}',
                              style: TextStyle(color: Colors.grey),
                            )
                          : Text(
                              "please Select bean type from the above available Options",
                              style: TextStyle(color: Colors.grey),
                            );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 90,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4), // horizontal, vertical offset
            ),
          ],

          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Price Column
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price",
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    Obx(() {
                      final size = cartItemVm.sizeOfCoffee.value;
                      final price = size == 'S'
                          ? item.smallPrice
                          : size == 'M'
                          ? item.mediumPrice
                          : item.largePrice;
                      return Text(
                        '\$${price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFFC67C4E),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Action Buttons
            Expanded(
              flex: 3,
              child: Obx(() {
                if (userProfileVM.isCurrentUserAdmin) {
                  return Row(
                    children: [
                      // Delete Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'Delete Item',
                              middleText:
                                  'Are you sure you want to delete this item?',
                              textCancel: 'No',
                              textConfirm: 'Yes',
                              onConfirm: () =>
                                  coffeeItemViewModel.deleteCoffeeItem(item),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC67C4E),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Delete",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Edit Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Get.toNamed('/createCoffeeUi', arguments: item),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC67C4E),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Edit",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Non-admin: either QuantitySelector or Add to Cart button
                  return cartItemVm.exists(item)
                      ? Row(
                        children: [
                          QuantitySelector(
                            item: cartItemVm.getCartItem(item)!,
                            onUpdate: (action) {
                              final cartItem = cartItemVm.getCartItem(item)!;
                              cartItemVm.updateCartItem(cartItem, action);
                            },
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Total:\n\$${cartItemVm.priceInCart().toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),


                        ],
                      )
                      : ElevatedButton(
                    onPressed: () {
                      cartItemVm.addToCart(item);
                      ScaffoldMessenger.of(context).showSnackBar(
                      buildAddToCartSnackBar(
                          cartItemVm.userSelectedBeanType.value.isNotEmpty&&
                              cartItemVm.userSelectedMilkType.value.isNotEmpty&&
                          cartItemVm.sizeOfCoffee.value.isNotEmpty?'Item Added To cart':'Please select all the options'
                      ),
                      );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC67C4E),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Add to Cart\n${cartItemVm.cartItems.isNotEmpty ? 'Total: \$${cartItemVm.priceInCart().toStringAsFixed(2)}' : ''}",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => CoffeeItemViewModel());
    Get.lazyPut(() => CoffeeMilkTypeVM());
    Get.lazyPut(() => FavoriteItemVM());
    Get.lazyPut(() => FavoritesRepo());
    Get.lazyPut(() => CartItemRepo());
    Get.lazyPut(() => MediaRepository());
    Get.lazyPut(() => CoffeeTypeRepo());
    Get.lazyPut(() => MilkTypeRepo());
    Get.lazyPut(() => CoffeeItemRepository());
  }
}
