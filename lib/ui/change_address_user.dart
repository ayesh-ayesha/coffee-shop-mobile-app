import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

import '../repos/user_profile_repo.dart';

class ChangeAddressUser extends StatefulWidget {
  const ChangeAddressUser({super.key});

  @override
  State<ChangeAddressUser> createState() => _ChangeAddressUserState();
}

class _ChangeAddressUserState extends State<ChangeAddressUser> {

  late UserProfileVM userProfileVM;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userProfileVM=Get.find();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProfileVM.selectedUser.value != null) {
        userProfileVM.displayNameController.text = userProfileVM.selectedUser.value!.displayName;
        userProfileVM.addressController.text = userProfileVM.selectedUser.value!.address??'';
        userProfileVM.cityController.text = userProfileVM.selectedUser.value!.city??'';
        userProfileVM.countryController.text = userProfileVM.selectedUser.value!.country??'';
        userProfileVM.phoneNumberController.text = userProfileVM.selectedUser.value!.phoneNumber??'';



        // Future.delayed(Duration.zero, () {
        //   coffeeItemViewModel.image.value=null;
        //   coffeeItemViewModel.selectedBeanOptions.value=coffeeItem!.beanType;
        //   coffeeItemViewModel.selectedMilkOptions.value=coffeeItem!.milkType;
        //   coffeeItemViewModel.selectedCategory.value=coffeeItem!.category;
        //   coffeeItemViewModel.availableForDelivery.value=coffeeItem!.availableForDelivery;
        // }
        // );
      }

      // if (coffeeItem == null) {
      //   coffeeItemViewModel.image.value = null;
      //   coffeeItemViewModel.selectedBeanOptions.clear();
      //   coffeeItemViewModel.selectedMilkOptions.clear();
      //   coffeeItemViewModel.selectedCategory.value = '';
      //   coffeeItemViewModel.availableForDelivery.value = false;
      // }

    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Address"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: userProfileVM.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
            
                buildTextField("Name", userProfileVM.displayNameController),
                buildTextField("Address", userProfileVM.addressController),
                buildTextField("City", userProfileVM.cityController),
                buildTextField("Country", userProfileVM.countryController),
                buildTextField("Phone Number", userProfileVM.phoneNumberController, keyboardType: TextInputType.phone),
            
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>{
                    userProfileVM.updateUserProfile(),
            
                  },
                  child: const Text("Save Changes"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


class ChangeAddressBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>UserProfileVM());
    Get.lazyPut(()=>UserProfileRepository());
  }

}