import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/view_model/CoffeeItemVM.dart';

import 'Grid_view_coffees.dart';
import 'custom_widgets.dart';

class HomePageBelow extends StatefulWidget {
  const HomePageBelow({super.key});

  @override
  State<HomePageBelow> createState() => _HomePageBelowState();
}

class _HomePageBelowState extends State<HomePageBelow> {
  late CoffeeItemViewModel coffeeItemViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coffeeItemViewModel = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This SingleChildScrollView is correct for horizontal scrolling categories
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CoffeeCategoriesWidget(
                    text: "All Coffee",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "All Coffee",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "All Coffee";
                      coffeeItemViewModel.filterCoffeeItemsByCategory(
                        "All Coffee",
                      );
                    },
                  ),
                  CoffeeCategoriesWidget(
                    text: "Mocha",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "Mocha",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "Mocha";
                      coffeeItemViewModel.filterCoffeeItemsByCategory(
                        "Mocha",
                      );
                    },
                  ),
                  CoffeeCategoriesWidget(
                    text: "Latte",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "Latte",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "Latte";
                      coffeeItemViewModel.filterCoffeeItemsByCategory("Latte");
                    },
                  ),
                  CoffeeCategoriesWidget(
                    text: "Americano",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "Americano",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "Americano";
                      coffeeItemViewModel.filterCoffeeItemsByCategory(
                        "Americano",
                      );
                    },
                  ),
                  CoffeeCategoriesWidget(
                    text: "Espresso",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "Espresso",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "Espresso";
                      coffeeItemViewModel.filterCoffeeItemsByCategory(
                        "Espresso",
                      );
                    },
                  ),  CoffeeCategoriesWidget(
                    text: "Cappuccino",
                    isSelected:
                        coffeeItemViewModel.selectedCategoryInHome.value ==
                        "Cappuccino",
                    onTap: () {
                      coffeeItemViewModel.selectedCategoryInHome.value =
                          "Cappuccino";
                      coffeeItemViewModel.filterCoffeeItemsByCategory(
                        "Cappuccino",
                      );
                    },
                  ),
                ],
              );
            }),
          ),

        ],
      ),
    );
  }
}
