import 'package:cloud_firestore/cloud_firestore.dart';


import '../models/coffee_item.dart';

class CoffeeItemRepository {
  late CollectionReference coffeeItemCollection;


  CoffeeItemRepository() {
    coffeeItemCollection = FirebaseFirestore.instance.collection('coffeeItems');

  }

  Future<void> addCoffeeItem(CoffeeItem coffeeItem) {
    var doc = coffeeItemCollection.doc();
    coffeeItem.id = doc.id;
    return doc.set(coffeeItem.toMap());
  }


  Future<void> updateCoffeeItem(CoffeeItem coffeeItem) {
    return coffeeItemCollection.doc(coffeeItem.id).set(coffeeItem.toMap());
  }

  Stream<List<CoffeeItem>> loadAllCoffeeItems() {
    return coffeeItemCollection.snapshots().map((snapshot) {
      return convertToCoffeeItems(snapshot);
    });
  }

  // utility function
  List<CoffeeItem> convertToCoffeeItems(QuerySnapshot snapshot) {
    List<CoffeeItem> products = [];
    for (var snap in snapshot.docs) {
      products.add(CoffeeItem.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<void> deleteCoffeeItem(CoffeeItem coffeeItem) {
    return coffeeItemCollection.doc(coffeeItem.id).delete();
  }

}
