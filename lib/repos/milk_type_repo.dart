import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/milkType.dart';

class MilkTypeRepo{
  late CollectionReference milkTypeCollection;
  MilkTypeRepo(){
    milkTypeCollection = FirebaseFirestore.instance.collection('milkTypes');
  }
  Future<void> addMilkType(MilkType milkType) {
    var doc = milkTypeCollection.doc();
    milkType.id = doc.id;
    return doc.set(milkType.toMap());
  }


  Future<void> updateMilkType(MilkType milkType) {
    return milkTypeCollection.doc(milkType.id).set(milkType.toMap());
  }

  Stream<List<MilkType>> loadAllMilkTypes() {
    return milkTypeCollection.snapshots().map((snapshot) {
      return convertToMilkTypes(snapshot);
    });
  }

  // utility function
  List<MilkType> convertToMilkTypes(QuerySnapshot snapshot) {
    List<MilkType> products = [];
    for (var snap in snapshot.docs) {
      products.add(MilkType.fromMap(snap.data() as Map<String, dynamic>));
    }
    return products;
  }

  Future<void> deleteMilkType(MilkType milkType) {
    return milkTypeCollection.doc(milkType.id).delete();
  }




}