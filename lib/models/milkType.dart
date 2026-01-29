import 'dart:core';

class MilkType {
  String id;
  String name;

  MilkType({
    required this.id,
    required this.name,
  });

  Map<String,dynamic> toMap(){
    return{
      'id':id,
      'name':name,
    };
  }

  factory MilkType.fromMap(Map<String, dynamic> map) {
    return MilkType(id: map['id'], name: map['name']);

  }




}