import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repos/cartItem_repo.dart';
import '../repos/user_profile_repo.dart';
import '../view_model/UserProfile_vm.dart';
import '../view_model/bottom_nav_bar_vm.dart';
import '../view_model/cart_item_VM.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late CartItemVM cartItemVM;

  @override
  void initState() {
    super.initState();
    cartItemVM = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    // Define a primary color for the app
    const Color primaryColor = Color(0xFFC67C4E);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Lighter background for a cleaner look
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
            color: Colors.black, // Dark text for contrast
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0, // Remove app bar shadow for a modern flat design
      ),
      body: SafeArea(
        child: Obx(() {
          final cartItems = cartItemVM.cartItems;

          if (cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Your cart is empty.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];

                    return CartItemCard(
                      item: item,
                      onAdd: () => cartItemVM.updateCartItem(item, 'add'),
                      onRemove: () => cartItemVM.updateCartItem(item, 'remove'),
                      onDelete: () => cartItemVM.deleteCartItem(item),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // ✅ Place Order Button
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      cartItemVM.placeOrderScreen();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Use the primary color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5, // Add a subtle shadow
                    ),
                    child: Text(
                      'Proceed to Checkout \$${cartItemVM.priceInCart().toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CartItemCard extends StatelessWidget {
  final dynamic item; // Use a more specific type if possible
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onDelete;

  const CartItemCard({
    Key? key,
    required this.item,
    required this.onAdd,
    required this.onRemove,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFC67C4E);

    return Card(
      elevation: 4, // More pronounced shadow for a floating effect
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Softer, more modern corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    item.coffeeItemImage,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),

                // Product details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.coffeeItemName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow('Size', item.selectedSize == 'M' ? 'Medium' : item.selectedSize == 'L' ? 'Large' : 'Small'),
                      _buildDetailRow('Bean', item.selectedBeanType),
                      _buildDetailRow('Milk', item.selectedMilkType),
                      const SizedBox(height: 8),
                      Text(
                        "\$${item.totalPrice.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor, // Highlight the price
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32, thickness: 1), // A clean divider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity: ${item.quantity}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: item.quantity > 1 ? const Icon(Icons.remove_circle_outline) : const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: item.quantity > 1 ? onRemove : () => _showDeleteDialog(context, onDelete),
                      color: primaryColor,
                    ),
                    Text(
                      item.quantity.toString(),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: onAdd,
                      color: primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, VoidCallback onConfirm) {
    Get.defaultDialog(
      title: "Remove Item",
      middleText: "Are you sure you want to remove this item from your cart?",
      textConfirm: "Yes, Remove",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        onConfirm();
        Get.back();
      },
      buttonColor: Colors.red,
      cancelTextColor: Colors.black,
    );
  }
}

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => BottomNavBarVM());
    Get.lazyPut(() => CartItemRepo());
    Get.lazyPut(() => UserProfileRepository());
  }
}