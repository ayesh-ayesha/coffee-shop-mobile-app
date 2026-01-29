import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repos/cartItem_repo.dart';
import '../repos/payment_repo.dart';
import '../repos/place_order_repo.dart';
import '../repos/user_profile_repo.dart';
import '../view_model/UserProfile_vm.dart';
import '../view_model/cart_item_VM.dart';
import '../view_model/paymentVm.dart';
import '../view_model/place_order_vm.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late PlaceOrderVM placeOrderVM;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    placeOrderVM = Get.find();
  }

  @override
  void dispose() {
    placeOrderVM.searchUserController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Order History', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() {
        final orders = placeOrderVM.userSearchedItems.isEmpty
            ? placeOrderVM.currentUserOrders
            : placeOrderVM.userSearchedItems;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: placeOrderVM.searchUserController,
                onChanged: (value) => placeOrderVM.searchUserOrderItem(value),
                decoration: InputDecoration(
                  hintText: 'Search by Order Status...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
            ),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/view_order_details', arguments: order);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          'Order ID: ${order.id}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Date: ${order.orderDate.toString()}'),
                            const SizedBox(height: 4),
                            Text('Total: \$${order.totalAmount.toStringAsFixed(2)}'),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFFC67C4E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            order.orderStatus,
                            style: const TextStyle(
                              color: Color(0xFFF9F2ED),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}



class OrderHistoryScreenBinding extends Bindings {
  @override
  void dependencies() {
    // Inject dependencies
    Get.lazyPut(() => PlaceOrderVM());
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => PaymentVM());
    Get.lazyPut(() => PaymentRepo());
    Get.lazyPut(() => UserProfileRepository());
    Get.lazyPut(() => CartItemRepo());
    Get.lazyPut(() => PlaceOrderRepo());
  }
}
