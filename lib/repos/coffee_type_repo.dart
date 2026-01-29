import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/coffeeType.dart';

class CoffeeTypeRepo{
  late CollectionReference coffeeTypeCollection;
  CoffeeTypeRepo(){
    coffeeTypeCollection = FirebaseFirestore.instance.collection('coffeeTypes');
  }
  Future<void> addCoffeeType(CoffeeType coffeeType) {
    var doc = coffeeTypeCollection.doc();
    coffeeType.id = doc.id;
    return doc.set(coffeeType.toMap());
  }

  Future<void> updateCoffeeType(CoffeeType coffeeType) {
    return coffeeTypeCollection.doc(coffeeType.id).set(coffeeType.toMap());
  }

  Stream<List<CoffeeType>> loadAllCoffeeTypes() {
    return coffeeTypeCollection.snapshots().map((snapshot) {
      return convertToCoffeeTypes(snapshot);
    });
  }

  // utility function
  List<CoffeeType> convertToCoffeeTypes(QuerySnapshot snapshot) {
    List<CoffeeType> products = [];
    for (var snap in snapshot.docs) {
      products.add(CoffeeType.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<void> deleteCoffeeType(CoffeeType coffeeType) {
    return coffeeTypeCollection.doc(coffeeType.id).delete();
  }


  // Future<void> addMultipleBeanOptions() async {
  //   List<String> coffeeNames = [
  //     'Arabica',
  //     'Robusta',
  //     'Liberica',
  //     'Excelsa',
  //   ];
  //
  //
  //   for (String name in coffeeNames) {
  //     // **Crucial Modification:** Check if the type already exists before adding
  //     bool exists = beanOptions.any((bean) => bean.name == name);
  //     if (!exists) {
  //       await coffeeTypeRepo.addCoffeeType(CoffeeType(id: '', name: name),
  //       );
  //     }
  //   }
  // }
}