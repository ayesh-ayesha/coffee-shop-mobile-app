import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/ui/home_page_below.dart';
import '../repos/auth_repo.dart';
import '../repos/cartItem_repo.dart';
import '../repos/coffeeItem_repo.dart';
import '../repos/coffee_type_repo.dart';
import '../repos/media_repo.dart';
import '../repos/milk_type_repo.dart';
import '../repos/user_profile_repo.dart';
import '../view_model/CoffeeItemVM.dart';
import '../view_model/UserProfile_vm.dart';
import '../view_model/coffee_milk_type_VM.dart';
import '../view_model/login_vm.dart';
import 'Grid_view_coffees.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LoginViewModel loginViewModel;
  late UserProfileVM userProfileVM;
  late CoffeeItemViewModel coffeeItemVM;
  String formatString(String input) {
    // Remove all whitespaces
    String cleaned = input.replaceAll(RegExp(r'\s+'), '');

    // Capitalize first letter of each word (assuming original words were separated)
    // Since we removed whitespaces, we can capitalize first letters only (if needed).
    // But if you want to *capitalize every first letter of originally separated words*, do it **before** removing whitespaces:

    List<String> words = input.trim().split(RegExp(r'\s+'));
    String capitalized = words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join('');

    return capitalized;
  }


  @override
  void initState() {
    super.initState();
    loginViewModel = Get.find();
    userProfileVM = Get.find();
    coffeeItemVM = Get.find();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String? currentUserId = loginViewModel.getCurrentUserId();
      if (currentUserId != null) {
        userProfileVM.fetchUserRealTimeById(currentUserId);
      }
    });
  }

  final FocusNode _searchFocusNode = FocusNode();
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void showOverlay() {
    if (_overlayEntry != null) return; // Already shown

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
              final items = coffeeItemVM.displayItems;
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child:
                  Text('No items found', style: TextStyle(color: Colors.white)),
                );
              }

              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      title: Text(item.name, style: TextStyle(color: Colors.white)),
                      onTap: () {
                        coffeeItemVM.searchController.text = item.name;
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // --- Responsive Calculations ---
    final double blackHeaderHeight = screenHeight * 0.3;
    final double responsiveOverlappingImageHeight = screenWidth * 0.3;
    final double positionedImageOffset = responsiveOverlappingImageHeight / 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Obx(() {
            final isLoading = userProfileVM.isLoading.value;
            final error = userProfileVM.errorMessage.value;
            final user = userProfileVM.selectedUser.value;
            return PopupMenuButton<int>(
              icon: const Icon(
                Icons.person,
                size: 28,
                color: Color(0xFFC67C4E),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (error.isNotEmpty)
                          Text(
                            "⚠️ $error",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          )
                        else if (user != null) ...[
                          Text(
                            "👤 ${user.displayName ?? 'No name'}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📧 ${user.email ?? 'No email'}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          DropdownButton<bool>(
                            value: user.isAdmin,
                            onChanged: user.email == 'ayesha@gmail.com'
                                ? (bool? newValue) {
                              if (newValue != null) {
                                Future.microtask(() {
                                  userProfileVM.updateStatus(newValue);
                                });
                              }
                            }
                                : null,
                            items: const [
                              DropdownMenuItem(
                                value: false,
                                child: Text("User"),
                              ),
                              DropdownMenuItem(
                                value: true,
                                child: Text("Admin"),
                              ),
                            ],
                          ),
                          Text(
                            "🔐 Role: ${user.isAdmin ? 'Admin' : 'User'}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ] else
                          const Text("No user data available"),
                        const SizedBox(height: 12),
                        const Divider(),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: loginViewModel.logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Nested Stack for the header and overlapping image
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Top black header section
                Container(
                  color: Colors.black,
                  height: blackHeaderHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Location",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Obx(() {
                              final user = userProfileVM.selectedUser.value;
                              String displayAddress = '';
                              if (user != null) {
                                final String fullAddress = user.address ?? '';
                                final String city = user.city ?? '';
                                final String addressPart = fullAddress.isNotEmpty
                                    ? formatString(fullAddress)
                                    : '';
                                if (addressPart.isNotEmpty && city.isNotEmpty) {
                                  displayAddress = '$addressPart, $city';
                                } else if (addressPart.isNotEmpty) {
                                  displayAddress = addressPart;
                                } else if (city.isNotEmpty) {
                                  displayAddress = city;
                                }
                              } else {
                                displayAddress = 'Loading address...';
                              }
                              return Text(
                                displayAddress,
                                style: const TextStyle(color: Colors.white),
                              );
                            }),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                Get.toNamed('/change_address_user');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: CompositedTransformTarget(
                                link: _layerLink,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [Color(0xFF3A3A3A), Color(0xFF2A2A2A)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: TextField(
                                    focusNode: _searchFocusNode,
                                    controller: coffeeItemVM.searchController,
                                    style: const TextStyle(color: Colors.white),
                                    onChanged: (value) {
                                      coffeeItemVM.searchCoffeeItem(value);
                                      if (_searchFocusNode.hasFocus && value.isNotEmpty) {
                                        showOverlay();
                                      } else {
                                        hideOverlay();
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Search Coffee',
                                      hintStyle: const TextStyle(color: Colors.white54),
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Image.asset('assets/icons/Search.png',
                                            color: Colors.white),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // The overlapping image, positioned relative to the nested Stack
                Positioned(
                  bottom: -positionedImageOffset -20,
                  left: 20,
                  right: 20,
                  top: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      height: responsiveOverlappingImageHeight + 26,
                      child: Image.asset(
                        'assets/images/Slice 1.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Spacer to create separation for the content below the image
            SizedBox(height: positionedImageOffset + 20),

            // Content below the image, now part of the scrollable column
            const HomePageBelow(),

            // GridView of coffees, also part of the scrollable column
            const GridViewCoffees(),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final bool isAdmin = userProfileVM.selectedUser.value?.isAdmin ?? false;
        return isAdmin
            ? FloatingActionButton.extended(
          onPressed: () {
            Get.toNamed('/createCoffeeUi');
          },
          backgroundColor: const Color(0xFFC67C4E),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add new Coffee",
            style: TextStyle(color: Colors.white),
          ),
        )
            : const SizedBox.shrink();
      }),
    );
  }
}

class MyHomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => CoffeeItemViewModel());
    Get.lazyPut(() => CoffeeMilkTypeVM());
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => UserProfileRepository());
    Get.lazyPut(() => CoffeeItemRepository());
    Get.lazyPut(() => MediaRepository());
    Get.lazyPut(() => CoffeeTypeRepo());
    Get.lazyPut(() => MilkTypeRepo());
    Get.lazyPut(() => CartItemRepo());
  }
}