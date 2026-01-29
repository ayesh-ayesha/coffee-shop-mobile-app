import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:layouts_flutter/repos/payment_repo.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

class PaymentVM extends GetxController{

  Map<String,dynamic>? paymentIntent;
  PaymentRepo paymentRepo=Get.find();
  var selectedPaymentMethod = "Cash On Delivery".obs;
  var isPaid=false.obs;
  UserProfileVM userProfileVM=Get.find();


//   make payment
Future<void> makePayment(String total) async {
  try{
    paymentIntent = await paymentRepo.createPaymentIntent(total, 'USD');
    if (paymentIntent == null) {
      Get.snackbar("Error", "Failed to create payment intent");
      return;
    }
    await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
    paymentIntentClientSecret: paymentIntent!['client_secret'],
      googlePay: PaymentSheetGooglePay(
          testEnv: true,
          currencyCode: 'USD',
          merchantCountryCode: 'US'),
      merchantDisplayName: userProfileVM.selectedUser.value!.displayName,
    ),);

  //   display payment sheet
   await displayPaymentSheet();
  }catch(e){
    debugPrint(e.toString());
  }
}

  displayPaymentSheet() async {
  try{
    await Stripe.instance.presentPaymentSheet();

    Get.snackbar('Payment', 'Payment Successful', colorText:Colors.white,backgroundColor: Color(0xFFC67C4E));
    isPaid.value=true;

  }
  on StripeException catch(e){
    isPaid.value=false;
    // Get.snackbar('Error', 'Payment Unsuccessful $e.toString()',colorText: Colors.white,backgroundColor: Colors.red);
    debugPrint("Unexpected error: $e");

  }catch (e) {
    isPaid.value = false;
    debugPrint("Unexpected error: $e");
    Get.snackbar('Error', 'Something went wrong', colorText: Colors.white, backgroundColor: Colors.red);
  }
  }


  }

