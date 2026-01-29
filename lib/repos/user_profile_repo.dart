
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserProfileRepository {
  late CollectionReference userProfileCollection;

  UserProfileRepository() {
    userProfileCollection = FirebaseFirestore.instance.collection(
      "userProfile",
    );
  }

  Future<void> addUserProfile(UserProfile userProfile) async {
    await userProfileCollection.doc(userProfile.id).set(userProfile.toMap());
  }

  Future<UserProfile?> getUserById(String userProfileId) async {
    DocumentSnapshot snapshot =
        await userProfileCollection.doc(userProfileId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return UserProfile.fromMap(data, snapshot.id);
    }
    return null;
  }
  Stream<UserProfile?> getUserProfileStreamById(String userProfileId) {
    return userProfileCollection.doc(userProfileId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Correctly pass the document ID to fromMap
        return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }

  Future<List<UserProfile>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await userProfileCollection.get();
      List<UserProfile> users =
          querySnapshot.docs.map((doc) {
            return UserProfile.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  Future<void> updateStatus(String uid, bool isAdmin) async {
    // var doc =
    await userProfileCollection.doc(uid).update({'isAdmin': isAdmin});
  }

   Future<void> updateTokens(String uid, String token) async {
    await userProfileCollection.doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token])
    });
  }


  Future<void> updateUserProfile(UserProfile userProfile) {
    return userProfileCollection.doc(userProfile.id).set(userProfile.toMap());
  }

  Stream<List<UserProfile>> loadCurrentUserProfile() {
    return userProfileCollection.snapshots().map((snapshot) {
      return convertToUser(snapshot);
    });
  }


  // utility function
  List<UserProfile> convertToUser(QuerySnapshot snapshot) {
    List<UserProfile> products = [];
    for (var snap in snapshot.docs) {
      products.add(UserProfile.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return products;
  }
}
