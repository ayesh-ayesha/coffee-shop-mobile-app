import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/ui/admin%20panel/orders_screen.dart';
import 'package:layouts_flutter/ui/cart_screen.dart';
import 'package:layouts_flutter/ui/my_home%20page.dart';
import 'package:layouts_flutter/ui/orderHistoryScreen.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

import '../ui/admin panel/notifications_screen.dart';
import '../ui/favorites_screen.dart';
import '../ui/item_details_screen.dart';

class BottomNavBarVM extends GetxController {

  UserProfileVM userProfileVM=Get.find ();
  // These are for nested navigation within BottomNavBar
  final pages = <String>['/home', '/favorites', '/cart', '/notifications'];
  var tabIndex = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
    Get.offAllNamed(pages[index], id: 1); // id: 1 for nested navigator
  }

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home':
        return GetPageRoute(
          settings: settings,
          page: () => MyHomePage(),
          binding: MyHomePageBinding(),
        );
      case '/favorites':
        return GetPageRoute(
          settings: settings,
          page: () => FavoritesScreen(),
          binding: FavoritesBindings(),
        );
      case '/cart':
        if (userProfileVM.isCurrentUserAdmin){
          return GetPageRoute(
            settings: settings,
            page: () => OrdersScreen(),
            binding:  OrderScreenBinding(),
          );
        }else{
        return GetPageRoute(
          settings: settings,
          page: () => CartScreen(),
          binding: CartBinding(),
        );}
      case '/notifications':
       if (!userProfileVM.isCurrentUserAdmin){
         return GetPageRoute(
           settings: settings,
           page: () => OrderHistoryScreen(),
             binding: OrderHistoryScreenBinding(),
         );}
      default:return null;

    }
    }
  }

