import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:layouts_flutter/repos/coffeeItem_repo.dart';
import 'package:rxdart/rxdart.dart';


import '../models/coffee_item.dart';
import '../models/favoriteItem.dart';

class FavoritesRepo {
  late CollectionReference favoriteItemCollection;
  CoffeeItemRepository coffeeItemRepository=CoffeeItemRepository();


  FavoritesRepo() {
    favoriteItemCollection = FirebaseFirestore.instance.collection('favoritesItems');
  }

  Future<void> addFavoriteItem(FavoriteItem favoriteItem) {
    var doc = favoriteItemCollection.doc();
    favoriteItem.id = doc.id;
    return doc.set(favoriteItem.toMap());
  }


  Future<void> updateFavoriteItem(FavoriteItem favoriteItem) {
    return favoriteItemCollection.doc(favoriteItem.id).set(favoriteItem.toMap());
  }

  Stream<List<CoffeeItem>> loadCurrentUserFavoriteItems() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      debugPrint("User not logged in");
      return const Stream.empty();
    }

    // 1. Get a stream of the current user's favorite items
    final favoriteItemsStream = favoriteItemCollection
        .where('userId', isEqualTo: currentUser.uid)
        .snapshots();

    // 2. Use switchMap to transform this stream into a stream of coffee items
    return favoriteItemsStream.switchMap((favoriteSnapshot) {
      // 3. Extract the list of coffeeItem IDs from the favorite items
      final favoriteItems = convertToFavoriteItems(favoriteSnapshot);
      final coffeeIds = favoriteItems.map((item) => item.productId).toList();

      // If there are no favorite items, return an empty stream
      if (coffeeIds.isEmpty) {
        return Stream.value([]);
      }

      // 4. Query the coffeeItem collection using the list of IDs
      // Firestore's 'where in' clause is perfect for this.
      return coffeeItemRepository.coffeeItemCollection
          .where(FieldPath.documentId, whereIn: coffeeIds)
          .snapshots()
          .map((coffeeSnapshot) => coffeeItemRepository.convertToCoffeeItems(coffeeSnapshot)); // Assuming you have this converter
    });
  }

  // utility function
  List<FavoriteItem> convertToFavoriteItems(QuerySnapshot snapshot) {
    List<FavoriteItem> products = [];
    for (var snap in snapshot.docs) {
      products.add(FavoriteItem.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<void> deleteFavoriteItem( favoriteItem) {
    return favoriteItemCollection.doc(favoriteItem.id).delete();
  }


  Future<void> deleteFavoriteItemByProductAndUser({required String coffeeId, required String userId}) async {
    // Query to find the favorite item document that matches both the coffeeId and userId
    final querySnapshot = await favoriteItemCollection
        .where('productId', isEqualTo: coffeeId)
        .where('userId', isEqualTo: userId)
        .limit(1) // We only expect one match
        .get();

    // If a document is found, delete it
    if (querySnapshot.docs.isNotEmpty) {
      final docRef = querySnapshot.docs.first.reference;
      await docRef.delete();
    } else {
      debugPrint("No matching favorite item found for deletion.");
    }
  }

}
