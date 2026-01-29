import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_profile.dart';
import '../repos/auth_repo.dart';
import '../repos/user_profile_repo.dart';

class UserProfileVM extends GetxController {
  UserProfileRepository userProfileRepository = Get.find();
  AuthRepository authRepository = Get.find();

  var usersProfile = <UserProfile>[].obs;
  var selectedUser = Rxn<UserProfile>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();


  // Add this getter to easily access current user's admin status
  bool get isCurrentUserAdmin => selectedUser.value?.isAdmin ?? false;
  String get getCurrentUserId => selectedUser.value!.id;


  String get customerName => selectedUser.value?.displayName ?? '';
  String get address => selectedUser.value?.address ?? '';
  String get city => selectedUser.value?.city ?? '';
  String get country => selectedUser.value?.country ?? '';
  String get phoneNumber => selectedUser.value?.phoneNumber ?? '';


  String get currentUserId =>
      authRepository
          .getLoggedInUser()
          ?.uid ?? '';



  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(selectedUser.value!=null){
      displayNameController.text=selectedUser.value!.displayName;
      addressController.text=selectedUser.value!.address!;
      cityController.text=selectedUser.value!.city!;
      countryController.text=selectedUser.value!.country!;
      phoneNumberController.text=selectedUser.value!.phoneNumber!;


      selectedUser.value!.address!;
      selectedUser.value!.city!;

    }



  }



  // Future<void> fetchUserById(String userId) async {
  //   try {
  //     isLoading.value = true;
  //     errorMessage.value = '';
  //
  //     UserProfile? user = await userProfileRepository.getUserById(userId);
  //
  //     if (user != null) {
  //       selectedUser.value = user;
  //     } else {
  //       errorMessage.value = 'User not found';
  //       selectedUser.value = null;
  //     }
  //   } catch (e) {
  //     debugPrint('Error fetching user: $e');
  //     errorMessage.value = 'Failed to fetch user: ${e.toString()}';
  //     selectedUser.value = null;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void fetchUserRealTimeById(String userId) {
    try {

      isLoading.value = true;
      errorMessage.value = '';

      // Bind stream to selectedUser
      selectedUser.bindStream(
        userProfileRepository.getUserProfileStreamById(userId),
      );
    } catch (e) {
      debugPrint('Error binding user stream: $e');
      errorMessage.value = 'Failed to stream user: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> updateUserProfile() async {
    if (!formKey.currentState!.validate()) return;
    if (phoneNumberController.text.isEmpty) {
      Get.snackbar('error', 'Enter your number its mandatory',colorText: Colors.white,backgroundColor: Colors.red);
    }
    if (addressController.text.isEmpty) {
      Get.snackbar('error', 'Enter your address its mandatory',colorText: Colors.white,backgroundColor: Colors.red);
    }
    if (cityController.text.isEmpty) {
      Get.snackbar('error', 'Enter your city its mandatory',colorText: Colors.white,backgroundColor: Colors.red);
    }
    if (countryController.text.isEmpty) {
      Get.snackbar('error', 'Enter your country its mandatory',colorText: Colors.white,backgroundColor: Colors.red);
    }
    if (displayNameController.text.isEmpty) {
      Get.snackbar('error', 'Enter your name its mandatory',colorText: Colors.white,backgroundColor: Colors.red);
    }
    try {
      UserProfile updateUserProfile = UserProfile(
          id: selectedUser.value!.id,
          email: selectedUser.value!.email,
          displayName: displayNameController.text,
          isAdmin: isCurrentUserAdmin,
        address: addressController.text,
        city: cityController.text,
        country: countryController.text,
        phoneNumber: phoneNumberController.text,
      );

      await userProfileRepository.updateUserProfile(updateUserProfile);
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to update user profile: ${e.toString()}",colorText: Colors.white,backgroundColor: Colors.red);
    }
  }


  void changeUserAddress() {
    Get.toNamed("/change_address_user");
    debugPrint("Change Address/Shipping pressed");
  }

  Future<void> updateStatus(bool isAdmin) async {
    String? uid = authRepository
        .getLoggedInUser()
        ?.uid;
    if (uid == null) {
      Get.snackbar("Error", "User not logged in",colorText: Colors.white,backgroundColor: Colors.red);
      return;
    }

    try {
      isLoading.value = true;
      await userProfileRepository.updateStatus(uid, isAdmin); // 1. Updates Firestore

      // 2. CRITICAL SECTION: Updating local selectedUser
      if (selectedUser.value != null) {
        selectedUser.value = UserProfile( // <--- THIS IS THE PROBLEM AREA!
          id: selectedUser.value!.id,
          email: selectedUser.value!.email,
          displayName: selectedUser.value!.displayName,
          isAdmin: isAdmin, // This is the updated value
          // !!! YOU ARE MISSING ALL OTHER FIELDS HERE !!!
          // If you don't explicitly pass them, they will become null or default.
        );
        selectedUser.refresh(); // This tells GetX to re-render UI
      }

      Get.snackbar("Success", "Role updated to ${isAdmin ? 'Admin' : 'User'}",colorText: Colors.white,backgroundColor: Color(0xFFC67C4E));
    } catch (e) {
      Get.snackbar("Error", "Failed to update role: ${e.toString()}",colorText: Colors.white,backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Add method to toggle role easily
  Future<void> toggleUserRole() async {
    bool currentRole = selectedUser.value?.isAdmin ?? false;
    await updateStatus(!currentRole);
  }
}


