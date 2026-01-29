import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/favoriteItem.dart';
import 'package:layouts_flutter/repos/favorites_repo.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';
import 'package:layouts_flutter/view_model/favoriteItem_vm.dart';
import '../view_model/app_Indicators_vm.dart';
import 'item_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late FavoriteItemVM favoriteItemVM;

  final Color primaryColor = const Color(0xFFC67C4E);


  @override
  void initState() {
    super.initState();
    favoriteItemVM = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Obx(() {
        if (favoriteItemVM.favoriteItemList.isEmpty) {
          return const Center(
            child: Text("No favorite items found."),
          );
        }

        return ListView.builder(
          itemCount: favoriteItemVM.favoriteItemList.length,
          itemBuilder: (context, index) {
            final item = favoriteItemVM.favoriteItemList[index];
            return GestureDetector(
              onTap: () {
              Get.to(() => ItemDetailsScreen(),arguments: item,binding: ItemDetailsScreenBinding());
            },

                child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Price: \$${item.smallPrice.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),

                  trailing: IconButton(
                    icon: Icon(Icons.favorite, color: primaryColor),
                    onPressed: () {
                      favoriteItemVM.deleteFavoriteItem(item);
                    },
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}


class FavoritesBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FavoriteItemVM());
    Get.lazyPut(() => AppIndicatorsVM());
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => FavoritesRepo());

  }
}
