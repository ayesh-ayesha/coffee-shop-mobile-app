import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/repos/coffee_type_repo.dart';
import 'package:layouts_flutter/repos/milk_type_repo.dart';

import '../models/coffeeType.dart';
import '../models/milkType.dart';

class CoffeeMilkTypeVM extends GetxController {
  CoffeeTypeRepo coffeeTypeRepo = Get.find();
  MilkTypeRepo milkTypeRepo = Get.find();

  final RxList<CoffeeType> beanOptions = <CoffeeType>[].obs;
  final RxList<MilkType> milkOptions = <MilkType>[].obs;

  final TextEditingController beanTypeController = TextEditingController();
  final TextEditingController milkTypeController = TextEditingController();


  @override
  void onInit() {
    super.onInit();

    loadAllMilkTypes();
    loadAllCoffeeTypes();
  }

  Future<void> addBeanType(String name, {CoffeeType? coffeeType}) async {
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name');
      return;
    }

    try {
      // ✅ For adding new bean type
      if (coffeeType == null) {
        bool alreadyExists = beanOptions.any(
              (item) => item.name.toLowerCase() == name.toLowerCase(),
        );

        if (!alreadyExists) {
          CoffeeType addBeanType = CoffeeType(id: '', name: name);
          await coffeeTypeRepo.addCoffeeType(addBeanType);
          Get.snackbar('Success', 'New bean type added');
          Get.back();
        } else {
          Get.snackbar('Error', 'Bean type already exists');
        }
      }
      // ✅ For updating existing bean type
      else {
        bool nameConflict = beanOptions.any(
              (item) =>
          item.name.toLowerCase() == name.toLowerCase() &&
              item.id != coffeeType.id,
        );

        if (!nameConflict) {
          CoffeeType updateBeanType = CoffeeType(id: coffeeType.id, name: name);
          await coffeeTypeRepo.updateCoffeeType(updateBeanType);
          Get.snackbar('Success', 'Bean type updated');
          Get.back();
        } else {
          Get.snackbar('Error', 'Another bean type with this name already exists');
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  Future<void> addMilkType(String name, {MilkType? milkType}) async {
    if (name.isEmpty) {
      Get.snackbar('Error', 'Please enter a name');
      return;
    }

    try {
      // ✅ For adding new milk type
      if (milkType == null) {
        // Prevent duplicates
        bool alreadyExists = milkOptions.any((item) => item.name.toLowerCase() == name.toLowerCase());
        if (!alreadyExists) {
          MilkType addMilkType = MilkType(id: '', name: name);
          await milkTypeRepo.addMilkType(addMilkType);
          Get.snackbar('Success', 'New milk type added');
          Get.back();
        } else {
          Get.snackbar('Error', 'Milk type already exists');
        }
      }
      // ✅ For editing existing milk type
      else {
        bool nameConflict = milkOptions.any((item) =>
        item.name.toLowerCase() == name.toLowerCase() && item.id != milkType.id);

        if (!nameConflict) {
          MilkType updateMilkType = MilkType(id: milkType.id, name: name);
          await milkTypeRepo.updateMilkType(updateMilkType);
          Get.snackbar('Success', 'Milk type updated');
          Get.back();
        } else {
          Get.snackbar('Error', 'Another milk type with this name already exists');
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void loadAllCoffeeTypes() {
    coffeeTypeRepo.loadAllCoffeeTypes().listen((data) {
      beanOptions.value = data; // ✅ This keeps the observable alive
    });
  }

  void loadAllMilkTypes() {
    milkTypeRepo.loadAllMilkTypes().listen((data) {
      milkOptions.value = data; // ✅ This keeps the observable alive
    });
  }

  void deleteCoffeeType(CoffeeType coffeeType) {
    coffeeTypeRepo.deleteCoffeeType(coffeeType);
  }

  void deleteMilkType(MilkType milkType) {
    milkTypeRepo.deleteMilkType(milkType);
  }

  Future<void> addMultipleBeanOptions() async {
    List<String> coffeeNames = ['Arabica', 'Robusta', 'Liberica', 'Excelsa'];

    for (String name in coffeeNames) {
      // **Crucial Modification:** Check if the type already exists before adding
      bool exists = beanOptions.any((bean) => bean.name == name);
      if (!exists) {
        await coffeeTypeRepo.addCoffeeType(CoffeeType(id: '', name: name));
      }
    }
  }

  Future<void> addMultipleMilkOptions() async {
    List<String> milkNames = [
      'Whole Milk',
      'Skim Milk',
      'Almond Milk',
      'OatMilk',
      'Soy Milk',
    ];
    for (String name in milkNames) {
      // **Crucial Modification:** Check if the type already exists before adding
      bool exists = milkOptions.any((milk) => milk.name == name);
      if (!exists) {
        await milkTypeRepo.addMilkType(MilkType(id: '', name: name));
      }
    }
  }
  Future<void> updateBeanType(CoffeeType bean, String newName) async {
    try {
      // You may update this based on your actual repo method
      await coffeeTypeRepo.updateCoffeeType(
        CoffeeType(id: bean.id, name: newName),
      );
      loadAllCoffeeTypes(); // Refresh the list
      Get.snackbar('Success', 'Bean type updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
  Future<void> updateMilkType(MilkType milk, String newName) async {
    try {
      // You may update this based on your actual repo method
      await milkTypeRepo.updateMilkType(
        MilkType(id: milk.id, name: newName),
      );
      loadAllCoffeeTypes(); // Refresh the list
      Get.snackbar('Success', 'Bean type updated');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

}
