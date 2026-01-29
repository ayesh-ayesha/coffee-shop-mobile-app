import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/view_model/CoffeeItemVM.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

import 'CoffeeItemWidget.dart';
import 'item_details_screen.dart';

class GridViewCoffees extends StatefulWidget {
  const GridViewCoffees({super.key});

  @override
  State<GridViewCoffees> createState() => _GridViewCoffeesState();
}

class _GridViewCoffeesState extends State<GridViewCoffees> {
  late CoffeeItemViewModel coffeeItemVM;
  late UserProfileVM userProfileVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coffeeItemVM=Get.find();
    userProfileVM=Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      coffeeItemVM.filterCoffeeItemsByCategory(
          coffeeItemVM.selectedCategoryInHome.value
      );
    });


  }
  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = constraints.maxWidth;
        double itemWidth = 180;
        int crossAxisCount = (screenWidth / itemWidth).floor().clamp(2, 4); // between 1 and 4 items per row

        return Obx(() {
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            itemCount:coffeeItemVM.selectedCategoryInHome.value=='All Coffee'?coffeeItemVM.displayItems.length:coffeeItemVM.categoriesFilteredItems.length,
            itemBuilder: (context, index) {
              final item = coffeeItemVM.selectedCategoryInHome.value=='All Coffee'?coffeeItemVM.displayItems[index]:coffeeItemVM.categoriesFilteredItems[index];
              return GestureDetector(
                onTap: () {
                  // if (userProfileVM.isCurrentUserAdmin) {
                    Get.to(
                      ItemDetailsScreen(),
                      arguments: item,
                      binding: ItemDetailsScreenBinding(),
                    );
                  // }
                },
                child: CoffeeItemWidget(item: item),
              );
            },
          );
        });
      },
    );
  }
}
