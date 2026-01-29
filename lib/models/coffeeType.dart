import 'dart:core';

class CoffeeType {
  String id;
  String name;

  CoffeeType({
    required this.id,
    required this.name,
  });
   Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
    };
  }

  factory CoffeeType.fromMap(Map<String, dynamic> map) {
    return CoffeeType(id: map['id'], name: map['name']);

  }

}