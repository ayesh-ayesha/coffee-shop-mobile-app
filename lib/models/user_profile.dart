class UserProfile {
  String id;
  String email;
  String displayName;
  String? address;
  String? city;
  String? country;
  String? phoneNumber;
  bool isAdmin;
  List<String> fcmTokens; // This is a list of strings!


  UserProfile({
    required this.id,
    required this.email,
    required this.displayName,
    this.address,
    this.city,
    this.country,
    this.phoneNumber,
    required this.isAdmin,
    this.fcmTokens = const [], // Initialize it as an empty list

  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
      'isAdmin': isAdmin,
      'address': address,
      'city':city,
      'country':country,
      'phoneNumber':phoneNumber,
      'fcmTokens': fcmTokens, // Store the list in your database

    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return UserProfile(
      id: documentId,
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      isAdmin: map['isAdmin'] ?? false, // We pass the document ID separately
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
        fcmTokens: List<String>.from(map['fcmTokens'] ?? []),


    );
  }
}
