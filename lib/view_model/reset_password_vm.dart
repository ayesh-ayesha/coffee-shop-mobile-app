
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../repos/auth_repo.dart';

class ResetPasswordVm extends GetxController {
  AuthRepository authRepository=Get.find();
  var isLoading=false.obs;

  Future<void> reset(String email) async {
    if (!email.contains('@')){
      Get.snackbar("Error", "Invalid Email");
      return;
    }

    isLoading.value=true;
    try{
      await authRepository.resetPassword(email);
      Get.snackbar("Success", "Password reset email sent to $email");
      Get.offAllNamed('/Login');
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error", e.message??' Failed to send reset password email');

      //error
    }finally{
      isLoading.value=false;

    }

  }


}