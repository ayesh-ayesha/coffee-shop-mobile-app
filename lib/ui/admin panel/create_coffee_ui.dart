import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/models/milkType.dart';
import 'package:layouts_flutter/repos/coffeeItem_repo.dart';
import 'package:layouts_flutter/repos/coffee_type_repo.dart';
import 'package:layouts_flutter/repos/media_repo.dart';
import 'package:layouts_flutter/repos/milk_type_repo.dart';
import 'package:layouts_flutter/view_model/CoffeeItemVM.dart';
import 'package:layouts_flutter/view_model/coffee_milk_type_VM.dart';

import '../../models/coffeeType.dart';
import '../../models/coffee_item.dart';
import 'cusom_widgets_admin.dart'; // Your ViewModel import

class CreateCoffeeUi extends StatefulWidget {
  const CreateCoffeeUi({super.key});

  @override
  State<CreateCoffeeUi> createState() => _CreateCoffeeUiState();
}

class _CreateCoffeeUiState extends State<CreateCoffeeUi> {
  // Lazily initialize your ViewModel using Get.find() in initState
  late CoffeeItemViewModel coffeeItemViewModel;
  late CoffeeMilkTypeVM coffeeMilkTypeVM;

  // Text editing controllers for form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController smallPriceController = TextEditingController();
  final TextEditingController mediumPriceController = TextEditingController();
  final TextEditingController largePriceController = TextEditingController();
  final TextEditingController longDescriptionController = TextEditingController();
  final TextEditingController milkTypeController = TextEditingController();
  final TextEditingController beanTypeController = TextEditingController();
  CoffeeItem? coffeeItem;
  void showEditBeanTypeDialog(CoffeeType bean) {
    final TextEditingController beanEditController = TextEditingController();
    beanEditController.text = bean.name;

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Bean Type'),
          content: TextField(
            controller: beanEditController,
            decoration: const InputDecoration(
              hintText: 'Enter new name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = beanEditController.text.trim();
                if (name.isNotEmpty) {
                  await coffeeMilkTypeVM.addBeanType(bean.name);
                  Get.back();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
  void showEditMilkTypeDialog(MilkType milk) {
    final TextEditingController milkEditController = TextEditingController();
    milkEditController.text = milk.name;

    showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Milk Type'),
          content: TextField(
            controller: milkEditController,
            decoration: const InputDecoration(
              hintText: 'Enter new name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = milkEditController.text.trim();
                if (name.isNotEmpty) {
                  await coffeeMilkTypeVM.addMilkType(milk.name);
                  Get.back();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }




  @override
  void initState() {
    super.initState();
    coffeeItemViewModel = Get.find();
    coffeeMilkTypeVM = Get.find();
    coffeeItem=Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (coffeeItem != null) {
        nameController.text = coffeeItem!.name;
        descriptionController.text = coffeeItem!.description;
        smallPriceController.text = coffeeItem!.smallPrice.toString();
        mediumPriceController.text = coffeeItem!.mediumPrice.toString();
        largePriceController.text = coffeeItem!.largePrice.toString();
        longDescriptionController.text = coffeeItem!.longDescription;


        Future.delayed(Duration.zero, () {
          coffeeItemViewModel.image.value=null;
          coffeeItemViewModel.selectedBeanOptions.value=coffeeItem!.beanType;
          coffeeItemViewModel.selectedMilkOptions.value=coffeeItem!.milkType;
          coffeeItemViewModel.selectedCategory.value=coffeeItem!.category;
          coffeeItemViewModel.availableForDelivery.value=coffeeItem!.availableForDelivery;
        }
        );
      }

      if (coffeeItem == null) {
        coffeeItemViewModel.image.value = null;
        coffeeItemViewModel.selectedBeanOptions.clear();
        coffeeItemViewModel.selectedMilkOptions.clear();
        coffeeItemViewModel.selectedCategory.value = '';
        coffeeItemViewModel.availableForDelivery.value = false;
      }

    });




  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    descriptionController.dispose();
    smallPriceController.dispose();
    mediumPriceController.dispose(); // Corrected: Remove the duplicate
    largePriceController.dispose(); // Added: Dispose largePriceController
    longDescriptionController.dispose();
    milkTypeController.dispose();   // Added: Dispose milkTypeController
    beanTypeController.dispose();   // Added: Dispose beanTypeController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Coffee'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.02,
        ),
        child: Form(
          key: coffeeItemViewModel.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Image Picker Section ---
              Center(
                child: GestureDetector(
                  onTap: coffeeItemViewModel.pickImage,
                  child: Obx(
                    () => Container(
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey),
                        image: coffeeItemViewModel.image.value != null
                            ? DecorationImage(
                                image: FileImage(
                                  File(coffeeItemViewModel.image.value!.path),
                                ),
                                fit: BoxFit.cover,
                              )
                            : coffeeItem!= null? DecorationImage(
                          image: NetworkImage(coffeeItem!.image),
                          fit: BoxFit.cover,
                        )
                            : null,
                      ),
                      child: coffeeItemViewModel.image.value == null && coffeeItem==null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  size: screenWidth * 0.1,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap to add Image',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              // --- Text Fields ---
              buildTextField(
                controller: nameController,
                labelText: 'Coffee Name',
                hintText: 'e.g., Espresso',
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a coffee name'
                    : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              buildTextField(
                controller: descriptionController,
                labelText: 'Short Description',
                hintText: 'e.g., Rich & bold.',
                maxLines: 2,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a short description'
                    : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              buildTextField(
                controller: smallPriceController,
                labelText: 'Enter Price of Small Item',
                hintText: 'e.g., 4.99',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a Small Item price';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  return null;
                },
              ),              SizedBox(height: screenHeight * 0.02),

              buildTextField(
                controller: mediumPriceController,
                labelText: 'Enter Price of Medium Item',
                hintText: 'e.g., 4.99',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a Medium Item price';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  return null;
                },
              ),              SizedBox(height: screenHeight * 0.02),

              buildTextField(
                controller: largePriceController,
                labelText: 'Enter Price of Large Item',
                hintText: 'e.g., 4.99',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Please enter a  Large Item price';
                  if (double.tryParse(value) == null)
                    return 'Please enter a valid number';
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.02),

              buildTextField(
                controller: longDescriptionController,
                labelText: 'Long Description',
                hintText: 'Detailed description of the coffee...',
                maxLines: 4,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a detailed description'
                    : null,
              ),
              SizedBox(height: screenHeight * 0.02),

              // --- Available for Delivery Checkbox ---
              Obx(() {
                return Row(
                  children: [
                    Checkbox(
                      // Access the .value of the RxBool
                      value: coffeeItemViewModel.availableForDelivery.value,
                      onChanged: (value) {
                        // Directly update the .value of the RxBool; Obx will handle the rebuild
                        coffeeItemViewModel.availableForDelivery.value =
                            value ?? false;
                      },
                      activeColor: Color(0xFF8B4513),
                    ),
                    const Text('Available for Delivery'),
                  ],
                );
              }),
              SizedBox(height: screenHeight * 0.02),

              // --- Milk Options (Multi-select Checkboxes) ---
              Text('Milk Options', style: sectionLabelStyle()),
              // Use the spread operator (...) to insert the list of CheckboxListTiles
          Obx(() {
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: coffeeMilkTypeVM.milkOptions.length,
              itemBuilder: (context, index) {
                final milk = coffeeMilkTypeVM.milkOptions[index];

                return Obx(() {
                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Options for "${milk.name}"'),
                            content: Text('Do you want to delete or edit this milk type?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  coffeeMilkTypeVM.deleteMilkType(milk);
                                  Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  coffeeMilkTypeVM.milkTypeController.text = milk.name;

                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Milk Type'),
                                        content: TextField(
                                          controller: coffeeMilkTypeVM.milkTypeController,
                                          decoration: const InputDecoration(
                                            hintText: 'Enter new milk name',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              final newName = coffeeMilkTypeVM.milkTypeController.text.trim();
                                              coffeeMilkTypeVM.addMilkType(newName, milkType: milk);
                                              Get.back();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text('Edit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: CheckboxListTile(
                      title: Text(milk.name),
                      value: coffeeItemViewModel.selectedMilkOptions.contains(milk.name),
                      onChanged: (value) {
                        if (value!) {
                          if (!coffeeItemViewModel.selectedMilkOptions.contains(milk.name)) {
                            coffeeItemViewModel.selectedMilkOptions.add(milk.name);
                          }
                        } else {
                          coffeeItemViewModel.selectedMilkOptions.remove(milk.name);
                        }
                      },
                    ),
                  );
                });
              },
            );
          }),

              TextButton(
                onPressed: () {
                  milkTypeController.clear(); // Optional: clear previous input
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add New Milk Type'),
                        content: TextField(
                          controller: milkTypeController,
                          decoration: InputDecoration(
                            hintText: 'Enter Milk type name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (milkTypeController.text.trim().isNotEmpty) {
                                coffeeMilkTypeVM.addMilkType(milkTypeController.text.trim());
                                Get.back(); // Close dialog
                              }
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add New Milk Type'), // Fixed label
              ),

              SizedBox(height: screenHeight * 0.02),

              // --- Bean Options (Multi-select Checkboxes) ---
              Text('Bean Options', style: sectionLabelStyle()),
              // Use the spread operator (...) to insert the list of CheckboxListTiles
    Obx(() {
    return ListView.builder(
    shrinkWrap: true, // Important if inside a Column
    physics: NeverScrollableScrollPhysics(), // Prevents internal scrolling
    itemCount: coffeeMilkTypeVM.beanOptions.length,
    itemBuilder: (context, index) {
    final bean = coffeeMilkTypeVM.beanOptions[index];

    return Obx(() {
      return GestureDetector(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Options for "${bean.name}"'),
                content: Text('Do you want to delete or edit this bean type?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      coffeeMilkTypeVM.deleteCoffeeType(bean);
                      Navigator.pop(context); // close dialog
                    },
                    child: const Text('Delete'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // close current dialog
                      coffeeMilkTypeVM.beanTypeController.text = bean.name; // 🟡 set current name

                      // Show edit dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Edit Bean Type'),
                            content: TextField(
                              controller: coffeeMilkTypeVM.beanTypeController,
                              decoration: const InputDecoration(
                                hintText: 'Enter new bean name',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  final newName = coffeeMilkTypeVM.beanTypeController.text.trim();
                                  coffeeMilkTypeVM.addBeanType(newName, coffeeType: bean);
                                  Get.back();
                                },
                                child: const Text('Save'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text('Edit'),
                  ),
                ],
              );
            },
          );
        },
        child: CheckboxListTile(
          title: Text(bean.name),
          value: coffeeItemViewModel.selectedBeanOptions.contains(bean.name),
          onChanged: (value) {
            if (value!) {
              coffeeItemViewModel.selectedBeanOptions.add(bean.name);
            } else {
              coffeeItemViewModel.selectedBeanOptions.remove(bean.name);
            }
          },
        ),
      );
    });
    },
    );
    }),
              TextButton(
                onPressed: () {
                  beanTypeController.clear();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Add New Bean Type'),
                        content: TextField(
                          controller: beanTypeController,
                          decoration: InputDecoration(
                            hintText: 'Enter bean type name',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (beanTypeController.text.trim().isNotEmpty) {
                                coffeeMilkTypeVM.addBeanType(beanTypeController.text.trim());
                                Get.back(); // Close dialog
                              }
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add New Bean Type'),
              ),
              SizedBox(height: screenHeight * 0.02),

              // --- Category Dropdown ---
              // Removed the extra Column for _buildDropdownField, it handles its own styling.
              Obx(() {
                return buildDropdownField(
                  labelText: 'Coffee Category',
                  // Ensure value is non-null for DropdownButton, or handle null case properly

                  value: coffeeItemViewModel.coffeeCategories.contains(coffeeItemViewModel.selectedCategory.value)
                    ? coffeeItemViewModel.selectedCategory.value
                    : null,

                // Provide a default if selectedCategory is null
                  items: coffeeItemViewModel.coffeeCategories,
                  onChanged: (value) {
                    // Directly update the .value of the RxString; Obx will handle the rebuild
                    coffeeItemViewModel.selectedCategory.value = value!;
                  },
                );
              }),
              SizedBox(height: screenHeight * 0.04),

              // --- Add Coffee Button ---
              Center(
                child: ElevatedButton(
                  onPressed: () =>{
                    coffeeItemViewModel.addCoffeeItem(
                      nameController.text,
                      descriptionController.text,
                      smallPriceController.text,
                      mediumPriceController.text,
                      largePriceController.text,
                      longDescriptionController.text,
                      coffeeItem,
                    )
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4513),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.1,
                      vertical: screenHeight * 0.02,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    coffeeItem == null ?
                    'Add Coffee':'Update Coffee',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateCoffeeAdminUIBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(CoffeeItemRepository());
    Get.put(MediaRepository());
    Get.put(MilkTypeRepo());
    Get.put(CoffeeTypeRepo());
    Get.put(CoffeeMilkTypeVM());
    Get.put(CoffeeItemViewModel());
  }
}
