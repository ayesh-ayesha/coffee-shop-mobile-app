import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/repos/cartItem_repo.dart';
import 'package:layouts_flutter/repos/payment_repo.dart';
import 'package:layouts_flutter/view_model/cart_item_VM.dart';
import 'package:layouts_flutter/view_model/paymentVm.dart';
import '../../repos/place_order_repo.dart';
import '../../view_model/place_order_vm.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late PlaceOrderVM placeOrderVM;

  final List<String> statusOptions = ['Pending', 'Processing', 'Delivered', 'Canceled'];
  final List<String> paymentStatusOptions = ['Pending', 'Paid', 'Failed', 'Refunded'];

  static const Color accentColor = Color(0xFF313131);
  static const Color primaryCoffeeColor = Color(0xFFC67C4E);

  @override
  void initState() {
    super.initState();
    placeOrderVM = Get.find();
  }



  Color getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green.shade700;
      case 'Processing':
        return Colors.orange.shade700;
      case 'Pending':
        return Colors.grey.shade600;
      case 'Canceled':
      case 'Failed':
        return Colors.red.shade700;
      case 'Paid':
        return Colors.green.shade700;
      case 'Refunded':
        return Colors.blue.shade700;
      default:
        return accentColor;
    }
  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    placeOrderVM.searchAdminController.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Admin Orders'),
        backgroundColor: Colors.white,
        foregroundColor: primaryCoffeeColor,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child:
            TextField(
              controller: placeOrderVM.searchAdminController,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                placeOrderVM.searchAdminOrderItem(value);
              },
              decoration: InputDecoration(
                hintText: 'Search Order',
                hintStyle: const TextStyle(color: Colors.black),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset('assets/icons/Search.png',
                      color: Colors.black),
                ),
              ),
            ),          ),

          // Order List
          Expanded(
            child: Obx(() {

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: placeOrderVM.adminSearchedItems.isEmpty?placeOrderVM.orderItemsList.length:placeOrderVM.adminSearchedItems.length,
                itemBuilder: (context, index) {
                  final order = placeOrderVM.adminSearchedItems.isEmpty?placeOrderVM.orderItemsList[index]:placeOrderVM.adminSearchedItems[index];

                  return Card(
                    elevation: 6,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID ${order.id}',
                            style: textTheme.bodyLarge?.copyWith(color: primaryCoffeeColor),
                          ),
                          const Divider(height: 24, thickness: 1, color: Colors.grey),
                          Text(
                            '\$ ${order.totalAmount.toStringAsFixed(2)}',
                            style: textTheme.bodyLarge?.copyWith(color: getStatusColor('Paid')),
                          ),
                          buildInfoRow(textTheme, 'Customer:', order.userName),
                          buildInfoRow(textTheme, 'Order Date:', '${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}'),
                          buildInfoRow(textTheme, 'Delivery Mode:', order.deliveryMode),
                          buildInfoRow(textTheme, 'Payment Method:', order.paymentMethod),
                          buildDropdownRow(textTheme, 'Order Status:', order.orderStatus, statusOptions, (newStatus) {
                            if (newStatus != null) {
                              placeOrderVM.updateOrderStatus(order.id, newStatus);
                              order.orderStatus = newStatus;
                              Get.snackbar("Updated", "Order status changed to $newStatus", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: primaryCoffeeColor);
                            }
                          }),
                          buildDropdownRow(textTheme, 'Payment Status:', order.paymentStatus, paymentStatusOptions, (newStatus) {
                            if (newStatus != null) {
                              placeOrderVM.updatePaymentStatus(order.id, newStatus);
                              order.paymentStatus = newStatus;
                              Get.snackbar("Updated", "Payment status changed to $newStatus", snackPosition: SnackPosition.BOTTOM, colorText: Colors.white, backgroundColor: primaryCoffeeColor);
                            }
                          }),
                          if (order.specialInstructions.isNotEmpty)
                            buildInfoRow(textTheme, 'Instructions:', order.specialInstructions, isInstruction: true),

                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryCoffeeColor,
                              ),
                              onPressed: () => Get.toNamed('/view_order_details', arguments: order),
                              icon: const Icon(Icons.visibility),
                              label: const Text('View Details'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildInfoRow(TextTheme textTheme, String title, String value, {bool isInstruction = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: isInstruction ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: accentColor)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                color: isInstruction ? primaryCoffeeColor.withOpacity(0.8) : Colors.black54,
                fontStyle: isInstruction ? FontStyle.italic : FontStyle.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownRow(TextTheme textTheme, String title, String currentValue, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: accentColor)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: options.contains(currentValue) ? currentValue : null,
                underline: Container(),
                isExpanded: true,
                onChanged: onChanged,
                style: textTheme.bodyMedium,
                dropdownColor: Colors.white,
                items: options.map((status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: textTheme.bodyMedium?.copyWith(
                        color: getStatusColor(status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlaceOrderVM());
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => PaymentVM());
    Get.lazyPut(() => PaymentRepo());
    Get.lazyPut(() => CartItemVM());
    Get.lazyPut(() => CartItemRepo());
    Get.lazyPut(() => PlaceOrderRepo());
  }
}
