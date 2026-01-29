import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/ui/item_details_screen.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';
import '../models/coffee_item.dart';
import 'custom_widgets.dart';

class CoffeeItemWidget extends StatefulWidget {
  final CoffeeItem item;

  const CoffeeItemWidget({super.key, required this.item});

  @override
  State<CoffeeItemWidget> createState() => _CoffeeItemWidgetState();
}

class _CoffeeItemWidgetState extends State<CoffeeItemWidget> {
  late UserProfileVM userProfileVM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfileVM=Get.find();
  }
  @override
  Widget build(BuildContext context) {
    // Get screen width to adapt layout size
    final screenWidth = MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = screenWidth < 400;

        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Image with Rating
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.item.image,
                      height: screenWidth * 0.25, // responsive height
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: RatingWidget(fontSize: isSmallScreen ? 10 : 12,),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ☕ Name
              Text(
                widget.item.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),

              const SizedBox(height: 4),

              // 📝 Description
              Text(
                widget.item.description,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isSmallScreen ? 10 : 12,
                ),
              ),

              const SizedBox(height: 10),

              // 💲 Price + Add Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${widget.item.smallPrice}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 12 : 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(()=>ItemDetailsScreen(),arguments: widget.item,binding: ItemDetailsScreenBinding());
                    },
                    child:Obx(
                       () {
                        return userProfileVM.isCurrentUserAdmin?SizedBox.shrink(): Image.asset(
                          'assets/icons/plus.png',
                          height: isSmallScreen ? 24 : 30,
                          width: isSmallScreen ? 24 : 30,

                        );
                      }
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
