import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/repos/cartItem_repo.dart';
import 'package:layouts_flutter/ui/custom_widgets.dart';
import 'package:layouts_flutter/view_model/app_Indicators_vm.dart';

import '../view_model/UserProfile_vm.dart';
import '../view_model/bottom_nav_bar_vm.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late BottomNavBarVM bottomNavBarVM;
  late UserProfileVM userProfileVM;
  late AppIndicatorsVM appIndicatorsVM;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bottomNavBarVM = Get.find();
    userProfileVM = Get.find();
    appIndicatorsVM = Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.offAllNamed(
        '/home',
        id: 1,
      ); // Use Get.offAllNamed for the initial route in the nested navigator
    });
  }

  // final List<Widget> _pages = [
  //   MyHomePage(), // Page for Home
  //   FavoritesScreen(), // Page for Favorites
  //   CartScreen(), // Page for Cart
  //   NotificationsScreen(), // Page for Notifications
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body:Obx(
      //       () => IndexedStack(
      //     index: bottomNavBarVM.tabIndex.value,
      //     children: _pages,
      //   ),
      // ),
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: '/home',
        onGenerateRoute: bottomNavBarVM.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          showUnselectedLabels: false,
          showSelectedLabels: false,

          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/home.svg',
                colorFilter: bottomNavBarVM.tabIndex == 0
                    ? const ColorFilter.mode(
                        Colors.orangeAccent,
                        BlendMode.srcIn,
                      )
                    : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Obx(
                 () {
                  return BadgeWidget(
                    color: Color(0xFFC67C4E),
                    showBadge:appIndicatorsVM.favoriteItemCount.value>0 ,
                    value: appIndicatorsVM.favoriteItemCount.value.toString(),
                    child: SvgPicture.asset(
                      'assets/icons/heart.svg',
                      colorFilter: bottomNavBarVM.tabIndex == 1

                          ? const ColorFilter.mode(
                              Colors.orangeAccent,
                              BlendMode.srcIn,
                            )
                          : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                    ),
                  );
                }
              ),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: userProfileVM.isCurrentUserAdmin
                  ? BadgeWidget(
                showBadge: appIndicatorsVM.orderItemCount.value>0,
                value: appIndicatorsVM.orderItemCount.value.toString(),
                color: Color(0xFFC67C4E),
                      child: Icon(
                        Icons.receipt_long_outlined,
                        color: bottomNavBarVM.tabIndex==2?Colors.orangeAccent:Colors.grey,
                      ),
                    )
                  : BadgeWidget(
                value: appIndicatorsVM.cartItemCount.value.toString(),
                    showBadge: appIndicatorsVM.cartItemCount.value > 0,

                    color: Color(0xFFC67C4E),
                    child: SvgPicture.asset(
                        'assets/icons/shopping_bag.svg',
                        colorFilter: bottomNavBarVM.tabIndex == 2
                            ? const ColorFilter.mode(
                                Colors.orangeAccent,
                                BlendMode.srcIn,
                              )
                            : const ColorFilter.mode(
                                Colors.grey,
                                BlendMode.srcIn,
                              ),
                      ),
                  ),
              label: 'Cart',
            ),
            if (!userProfileVM.isCurrentUserAdmin)
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.history_edu_outlined,
                  color:
                  bottomNavBarVM.tabIndex == 3 ? Colors.orangeAccent : Colors.grey,
                ),
                label: 'History',
              ),
          ],
          currentIndex: bottomNavBarVM.tabIndex.value,
          selectedItemColor: Colors.pink,
          onTap: bottomNavBarVM.changeTabIndex,
        ),
      ),
    );
  }
}

class BottomNavBarBinding extends Bindings {
  @override
  void dependencies() {
    // Controllers
    Get.lazyPut(() => BottomNavBarVM());
    Get.lazyPut(() => AppIndicatorsVM());
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => CartItemRepo());
  }
}
