import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:layouts_flutter/view_model/cart_item_VM.dart';

import '../models/cartItem.dart';

// class CoffeeCategoriesWidget extends StatefulWidget {
//   final String text;
//   final Color color;
//   const CoffeeCategoriesWidget({required this.text,  this.color = const Color(0xFFF5F5F5), super.key});
//
//   @override
//   State<CoffeeCategoriesWidget> createState() => _CoffeeCategoriesWidgetState();
// }
//
// class _CoffeeCategoriesWidgetState extends State<CoffeeCategoriesWidget> {
//   @override
//   Widget build(BuildContext context) {
//     // ✅ Get screen size
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//
//     return Padding(
//       padding: EdgeInsetsGeometry.directional(start: 3,end: 3,top: 3),
//       child: Container(
//         height: screenHeight * 0.05, // 8% of total height
//         width: screenWidth * 0.3,    // 90% of screen width
//
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: widget.color,
//           shape: BoxShape.rectangle,
//         ),
//         child: Center(child: Text(widget.text)),
//       ),
//     );
//
//   }
// }
import '../view_model/bottom_nav_bar_vm.dart';

class CoffeeCategoriesWidget extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const CoffeeCategoriesWidget(
      {super.key, required this.text, required this.isSelected, required this.onTap, this.color = const Color(
          0xFFF5F5F5),});

  @override
  Widget build(BuildContext context) {
    // ✅ Get screen size
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: GestureDetector(
        onTap: onTap, child: Container(height: screenHeight * 0.05,
        // same as before
        width: screenWidth * 0.3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFC67C4E) : color,
          shape: BoxShape.rectangle,),
        child: Center(child: Text(text, style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,),),),),),);
  }
}

class BadgeWidget extends StatelessWidget {
  final Widget child; // The icon or widget to place the badge on
  final String? value; // The text to display in the badge (e.g., "3", "99+")
  final Color? color; // The background color of the badge
  final bool showBadge; // Whether to show the badge at all

  const BadgeWidget(
      {super.key, required this.child, this.value, this.color, this.showBadge = true, // Default to showing the badge
      });

  @override
  Widget build(BuildContext context) {
    if (!showBadge) {
      return child; // If not showing badge, just return the child
    }

    // Determine if it's a count badge or just a dot
    final bool isCountBadge = value != null && value!.isNotEmpty;

    return Stack(clipBehavior: Clip.none, // Allow badge to overflow
      children: [child, // Your actual icon
        Positioned(
          top: isCountBadge ? -5 : -2, // Adjust position for count vs. dot
          right: isCountBadge ? -8 : -2, child: Container(padding: EdgeInsets
            .all(isCountBadge ? 3 : 4),
          // Padding based on content
          decoration: BoxDecoration(color: color ?? Colors.red,
            // Default to red if no color provided
            shape: isCountBadge ? BoxShape.rectangle : BoxShape.circle,
            borderRadius: isCountBadge ? BorderRadius.circular(10) : null,
            border: isCountBadge
                ? Border.all(color: Colors.white, width: 1.5)
                : null, // Optional white border
          ),
          constraints: BoxConstraints(minWidth: isCountBadge ? 18 : 8,
            // Minimum size for visibility
            minHeight: isCountBadge ? 18 : 8,),
          child: isCountBadge ? Text(value!, style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.center,) : null, // No child for a dot badge
        ),),
      ],);
  }
}


class IconsOnDetailsPage extends StatelessWidget {
  final String image;
  final Color? color;
  final bool? isActive;
  final bool? isIcon;

  const IconsOnDetailsPage({
    super.key,
    required this.image,
    this.color = const Color(0xFFC67C4E),
    this.isActive = false,
    this.isIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Image.asset(
              image,
              height: 24,
              width: 20,
              color: color,
              fit: BoxFit.contain,
            ),
          ),
        ),
         Positioned(
          right: 7,
          child: Icon(
            Icons.arrow_drop_down_sharp,
            size: 16,
            color: Color(0xFFC67C4E),
          ),
        )
      ],
    );
  }
}

class RatingWidget extends StatelessWidget {
  final Color? color;
  final int fontSize;
  final double? wSize;

  const RatingWidget({super.key, this.color = Colors
      .white, required this.fontSize, this.wSize = 12});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(height: wSize,
        width: wSize,
        child: Icon(Icons.star, color: Color(0xFFFBBE21), size: wSize,),),
      const SizedBox(width: 4),
      Text(
        "4.8", style: TextStyle(color: color, fontSize: fontSize.toDouble(),),),
    ],);
  }
}

class SizeOfCoffee extends StatelessWidget {
  final String size;
  final bool isActive;
  final VoidCallback onTap;

  const SizeOfCoffee(
      {super.key, required this.size, required this.isActive, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: onTap, child: Padding(padding: const EdgeInsets.symmetric(
        horizontal: 2), child: Container(height: 40,
      width: 40,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isActive ? Color(0xFFC67C4E) : Colors.grey.shade300),
        color: isActive ? const Color(0xFFF9F2ED) : Colors.white,),
      child: Center(child: Text(size, style: TextStyle(color: isActive ? Color(
          0xFFC67C4E) : Colors.black, fontWeight: FontWeight.bold,),),),),),),);
  }
}

void showFloatingMessage(BuildContext context, Offset position,
    String message) {
  final overlay = Overlay.of(Get.overlayContext!);
  final overlayEntry = OverlayEntry(builder: (context) =>
      Positioned(left: position.dx -30,
        top: position.dy,
        // appears slightly above the finger
        child: Material(color: Colors.transparent, child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: Color(0xFFC67C4E),
            borderRadius: BorderRadius.circular(8),),
          child: Text(message,
            style: TextStyle(color: Colors.white, fontSize: 13),),),),),);

  overlay.insert(overlayEntry);

  Future.delayed(Duration(seconds: 1)).then((_) => overlayEntry.remove());
}


class QuantitySelector extends StatefulWidget {
  final CartItem item;
  final Function(String action) onUpdate;

  const QuantitySelector(
      {Key? key, required this.item, required this.onUpdate,})
      : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
   CartItemVM cartItemVM=Get.find();
   Timer? _debounceTimer;


   @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // 👈 prevents overflow by shrinking
      children: [
        const Text(
          "Qty:", style: TextStyle(fontSize: 14), // slightly smaller for space
        ),
        const SizedBox(width: 3),
        Container(
          height: 30,
          // 👈 Shrinks container height
          constraints: const BoxConstraints(minWidth: 50),
          // 👈 Optional: set min width
          decoration: BoxDecoration(border: Border.all(
              color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon:   widget.item.quantity==1?IconButton(onPressed:()=>cartItemVM.deleteCartItem(widget.item), icon: Icon(Icons.delete,size: 12,)): Icon(Icons.remove, size: 12),

// You will need to define a timer variable in your stateful widget class.
// For example:
// Timer? _debounceTimer;

// This is the updated onPressed function.

    onPressed: () {
    // First, we update the cart immediately.
    widget.onUpdate('remove');

    // Cancel the previous timer if it exists.
    // This is the key to preventing the snackbar from showing repeatedly.
    _debounceTimer?.cancel();

    // Start a new timer.
    // The snackbar will only be shown after this delay (e.g., 500 milliseconds)
    // has passed without the user tapping the button again.
     _debounceTimer = Timer(const Duration(seconds: 2), () {
    // This code will only run after the timer has finished.
    ScaffoldMessenger.of(context).showSnackBar(
    buildAddToCartSnackBar('Item removed from the cart'),
    );
    // You can also add other actions here that you only want to happen once.
    }
    );
    },
                constraints: const BoxConstraints(),
                // No default padding
                padding: EdgeInsets.zero,
                // Minimal padding
                visualDensity: VisualDensity
                    .compact, // 👈 Shrinks clickable area
              ),
            Text(widget.item.quantity.toString(),
                style: const TextStyle(fontSize: 10),),
              IconButton(
                icon: const Icon(Icons.add, size: 12),
                  onPressed: () {
                  widget.onUpdate('add');
                  _debounceTimer?.cancel();

                  _debounceTimer=Timer(const Duration(seconds:2), (){
                  ScaffoldMessenger.of(context).showSnackBar(
                    buildAddToCartSnackBar('Item Added to Cart'),
                  );});
                  },

                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,),
            ],),)
      ],);
  }
}

Widget buildSectionTitle(String title) {
  return Text(title,
    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),);
}



SnackBar buildAddToCartSnackBar(String message) {
  return SnackBar(
    backgroundColor: const Color(0xFFC67C4E),
    duration: const Duration(seconds: 6),
    behavior: SnackBarBehavior.floating,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 4,
          children: [
            TextButton(
              onPressed: () {
                Get.until((route) => Get.currentRoute == '/bottom_nav_bar');
                Get.toNamed('/cart', id: 1);
                Get.find<BottomNavBarVM>().changeTabIndex(2);
              },
              child: const Text(
                'See Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.until((route) => Get.currentRoute == '/bottom_nav_bar');
                Get.toNamed('/home', id: 1);
                Get.find<BottomNavBarVM>().changeTabIndex(0);
              },
              child: const Text(
                'Shop More',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();

              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}





class SearchOverlayHelper {
  final FocusNode searchFocusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  final BuildContext context;
  final RxList<dynamic> displayItems; // Rx list of search results
  final TextEditingController searchController;

  SearchOverlayHelper({
    required this.context,
    required this.displayItems,
    required this.searchController,
  });

  LayerLink get layerLink => _layerLink;
  FocusNode get focusNode => searchFocusNode;

  void showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 60,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(10),
            child: Obx(() {
              if (displayItems.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('No items found', style: TextStyle(color: Colors.white)),
                );
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: displayItems.length,
                  itemBuilder: (context, index) {
                    final item = displayItems[index];
                    return ListTile(
                      title: Text(item.name, style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        searchController.text = item.name;
                        hideOverlay();
                        FocusScope.of(context).unfocus();
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}




