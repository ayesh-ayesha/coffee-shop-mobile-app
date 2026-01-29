class CoffeeItem {
  String id;
  String image; // URL or path to image
  String name;
  String description; // This will be the short description
  double smallPrice;
  double mediumPrice;
  double largePrice;
  String longDescription; // This is the detailed description
  int rating;
  int reviewCount;
  bool availableForDelivery;
  List<String> beanType; // Corrected: List<String>
  List<String> milkType; // Corrected: List<String>
  String category; // Corrected: Renamed from 'Category' to 'category' for Dart conventions

  // Constructor
  CoffeeItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.smallPrice,
    required this.mediumPrice,
    required this.largePrice,
    required this.longDescription,
    this.rating = 0, // Default value
    this.reviewCount = 0, // Default value
    this.availableForDelivery = true, // Default value
    this.beanType = const [], // Default empty list
    this.milkType = const [], // Default empty list
    required this.category, // Must be provided
  });

  // Factory constructor for creating a CoffeeItem from a Firestore Map
  factory CoffeeItem.fromMap(Map<String, dynamic> map) {
    return CoffeeItem(
      id: map['id'] as String, // Ensure type safety with 'as String'
      image: map['image'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      smallPrice: (map['smallPrice'] as num).toDouble(), // Firebase stores numbers as num, convert to double
      mediumPrice: (map['mediumPrice'] as num).toDouble(),
      largePrice: (map['largePrice'] as num).toDouble(),
      longDescription: map['longDescription'] as String,
      rating: map['rating'] as int? ?? 0,
      reviewCount: map['reviewCount'] as int? ?? 0,
      availableForDelivery: map['availableForDelivery'] as bool? ?? true,

      // For lists, cast to List<dynamic> first, then map to List<String>
      beanType: (map['beanType'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      milkType: (map['milkType'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      category: map['category'] as String, // Ensure consistent key name
    );
  }

  // Method for converting a CoffeeItem object to a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'description': description,
      'smallPrice': smallPrice,
      'mediumPrice': mediumPrice,
      'largePrice': largePrice,
      'longDescription': longDescription,
      'rating': rating,
      'reviewCount': reviewCount,
      'availableForDelivery': availableForDelivery,
      'beanType': beanType, // Lists are directly supported by Firestore
      'milkType': milkType, // Lists are directly supported by Firestore
      'category': category, // Ensure consistent key name
    };
  }

  }
