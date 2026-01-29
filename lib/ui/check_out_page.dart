import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repos/cartItem_repo.dart';
import '../repos/payment_repo.dart';
import '../repos/place_order_repo.dart';
import '../repos/user_profile_repo.dart';
import '../view_model/UserProfile_vm.dart';
import '../view_model/bottom_nav_bar_vm.dart';
import '../view_model/cart_item_VM.dart';
import '../view_model/paymentVm.dart';
import '../view_model/place_order_vm.dart';

// You can create a file for custom widgets or keep this for now
class CustomWidgets {
  static Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333), // A darker, more elegant color
      ),
    );
  }
}

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late CartItemVM cartItemVM;
  late UserProfileVM userProfileVM;
  late PlaceOrderVM placeOrderVM;
  late PaymentVM paymentVM;

  // Define a primary and background color for a consistent theme
  static const Color primaryColor = Color(0xFFC67C4E);
  static const Color backgroundColor = Color(0xFFF9F9F9);

  @override
  void initState() {
    super.initState();
    cartItemVM = Get.find();
    userProfileVM = Get.find();
    placeOrderVM = Get.find();
    paymentVM = Get.find();

    // The ever() method is good, keep it
    ever(cartItemVM.cartItems, (_) {
      placeOrderVM.calculatePrice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Checkout", // A more common and clear term
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5, // Subtle shadow for the app bar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Use stretch for full-width sections
            children: [
              // 1. Order Summary Section
              CustomWidgets.buildSectionTitle("Order Summary"),
              const SizedBox(height: 12.0),
              _buildOrderSummaryCard(),
              const SizedBox(height: 24.0),

              // 2. Shipping Address Section
              CustomWidgets.buildSectionTitle("Shipping Address"),
              const SizedBox(height: 12.0),
              _buildShippingAddressCard(),
              const SizedBox(height: 24.0),

              // 3. Payment Information Section
              CustomWidgets.buildSectionTitle("Payment Information"),
              const SizedBox(height: 12.0),
              _buildPaymentInfoCard(),
              const SizedBox(height: 24.0),

              // 4. Special Instructions Section
              CustomWidgets.buildSectionTitle("Special Instructions"),
              const SizedBox(height: 12.0),
              _buildSpecialInstructionsCard(),
              const SizedBox(height: 24.0),

              // 5. Total Amount Section
              _buildTotalAmountCard(),
              const SizedBox(height: 24.0),

              // 6. Terms & Conditions/Policies
              _buildTermsAndConditions(),
              const SizedBox(height: 24.0),

              // 7. Place Order Button
              _buildPlaceOrderButton(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Refactored Helper Widgets for a cleaner UI ---
  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return _buildCard(
      child: Obx(
            () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item List
              ...cartItemVM.cartItems.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "${item.coffeeItemName} (x${item.quantity})",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Text(
                      "\$${item.totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )),
              const Divider(height: 30, thickness: 1, color: Colors.grey),
              // Price breakdown
              Obx(() => _buildPriceRow("Subtotal", "\$${placeOrderVM.subtotal.toStringAsFixed(2)}")),
              const SizedBox(height: 8.0),
              _buildPriceRow("Shipping Fee", "\$${placeOrderVM.shippingFee.value.toStringAsFixed(2)}"),
              const SizedBox(height: 8.0),
              Obx(() => _buildPriceRow("Taxes", "\$${placeOrderVM.taxes.value.toStringAsFixed(2)}")),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 20.0 : 16.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? Colors.black87 : Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20.0 : 16.0,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? primaryColor : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildShippingAddressCard() {
    return _buildCard(
      child: Obx(
            () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userProfileVM.selectedUser.value!.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 4),
              Text(userProfileVM.selectedUser.value!.address ?? '', style: const TextStyle(fontSize: 16)),
              Text("${userProfileVM.selectedUser.value!.city ?? ''}, ${userProfileVM.selectedUser.value!.country ?? ''}", style: const TextStyle(fontSize: 16)),
              Text(userProfileVM.selectedUser.value!.phoneNumber ?? '', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Shipping Method:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(placeOrderVM.shippingMethod.value),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    userProfileVM.changeUserAddress();
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Change", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Select Payment Method:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          const SizedBox(height: 8.0),
          Obx(
                () => RadioListTile<String>(
              value: "Cash On Delivery",
              groupValue: paymentVM.selectedPaymentMethod.value,
              title: const Text("Cash On Delivery", style: TextStyle(fontSize: 16)),
              onChanged: (value) {
                paymentVM.selectedPaymentMethod.value = value!;
              },
              activeColor: primaryColor, // Use the primary color for the active state
            ),
          ),
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
          Obx(
                () => RadioListTile<String>(
              value: "Online Payment",
              groupValue: paymentVM.selectedPaymentMethod.value,
              title: const Text("Online Payment", style: TextStyle(fontSize: 16)),
              onChanged: (value) {
                paymentVM.selectedPaymentMethod.value = value!;
              },
              activeColor: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialInstructionsCard() {
    return _buildCard(
      child: TextField(
        controller: placeOrderVM.specialInstructionsController,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: "Add any instructions for your order",
          hintText: "e.g., No sugar, extra cream, etc.",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero, // Remove inner padding to align with card padding
          labelStyle: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildTotalAmountCard() {
    return _buildCard(
      child: Obx(
            () => _buildPriceRow(
          paymentVM.isPaid.value == true ? 'You Have Paid' : "Total Amount Due",
          "\$${placeOrderVM.calculatePrice().toStringAsFixed(2)}",
          isTotal: true,
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24.0,
          width: 24.0,
          child: Checkbox(
            value: true,
            onChanged: (bool? newValue) {
              // TODO: Handle checkbox state change
            },
            activeColor: primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // TODO: Navigate to Terms & Conditions page
            },
            child: const Text.rich(
              TextSpan(
                text: "By placing order, you agree to our ",
                style: TextStyle(fontSize: 14.0, color: Colors.black54),
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: "."),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Obx(
            () {
          final buttonText = paymentVM.selectedPaymentMethod.value == "Cash On Delivery"
              ? "Place Order"
              : 'Pay and Checkout';
          return ElevatedButton(
            onPressed: () {
              placeOrderVM.placeOrder();
            },
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 5,
            ),
          );
        },
      ),
    );
  }
}

class CheckOutPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => PlaceOrderVM());
    Get.lazyPut(() => BottomNavBarVM());
    Get.lazyPut(() => PaymentVM());
    Get.lazyPut(() => PaymentRepo());
    Get.lazyPut(() => PlaceOrderRepo());
    Get.lazyPut(() => UserProfileRepository());
    Get.lazyPut(() => CartItemRepo());
  }
}