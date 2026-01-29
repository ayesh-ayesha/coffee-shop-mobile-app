import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/orderItem.dart';
import 'package:layouts_flutter/repos/user_profile_repo.dart';
import '../../view_model/UserProfile_vm.dart';

class ViewOrderDetailsScreen extends StatefulWidget {
  const ViewOrderDetailsScreen({super.key});

  @override
  State<ViewOrderDetailsScreen> createState() => _ViewOrderDetailsScreenState();
}

class _ViewOrderDetailsScreenState extends State<ViewOrderDetailsScreen> {
  late OrderItem order;
  late UserProfileVM userProfileVM;

  @override
  void initState() {
    super.initState();
    order = Get.arguments;
    userProfileVM = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Lighter background color
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userProfileVM.isCurrentUserAdmin) ...[
              _buildOrderSummaryCard(),
              const SizedBox(height: 24),
            ],
            userProfileVM.isCurrentUserAdmin?_buildSectionTitle("🛍️ Ordered Products"):Container(),
            const SizedBox(height: 16),
            ...order.items.map((item) => _buildProductCard(item)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Color(0xFF2C2C2C),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Container(
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F2D2C),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow("Order ID", order.id),
            _buildInfoRow("User Name", order.userName),
            _buildInfoRow("Date", order.orderDate.toString().split(' ')[0]),
            _buildInfoRow("Delivery Mode", order.deliveryMode),
            _buildInfoRow("Payment", "${order.paymentMethod} (${order.paymentStatus})"),
            _buildInfoRow("Status", order.orderStatus, status: true),
            if (order.specialInstructions.isNotEmpty)
              _buildInfoRow("Instructions", order.specialInstructions),
            const Divider(height: 24, thickness: 1),
            _buildInfoRow("Total", "Rs. ${order.totalAmount.toStringAsFixed(2)}", isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, bool status = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text("$label:")),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: status ? Colors.green : Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B6B6B),
              fontSize: 15,
            ),
          ),
          Expanded(
            child: Chip(
              label: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: _getStatusColor(value),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Color(0xFFC67C4E);
      case 'cancelled':
        return Color(0xFF313131);
      default:
        return Color(0xFFEDD6C8);
    }
  }

  Widget _buildTotalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF2F2D2C),
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFFC67C4E), // Your app's accent color
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    final quantity = item['quantity'] ?? 0;
    final price = item['price'] ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item['image'] ?? 'https://via.placeholder.com/150',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.coffee, size: 70, color: Colors.brown),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? 'Unknown Coffee',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2D2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetail("Qty", quantity.toString()),
                  _buildDetail("Size", item['selectedSize'] ?? 'N/A'),
                  _buildDetail("Bean", item['beanType'] ?? 'N/A'),
                  _buildDetail("Milk", item['selectedMilkType'] ?? 'N/A'),
                  const SizedBox(height: 8),
                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFC67C4E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8D8D8D),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF444444),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewOrderDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => UserProfileRepository());
  }
}