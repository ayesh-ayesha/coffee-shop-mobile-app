import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:layouts_flutter/repos/notifications_repo.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';
import 'package:layouts_flutter/view_model/place_order_vm.dart';

class NotificationsVM {

  PlaceOrderVM placeOrderVM=Get.find();
  UserProfileVM userProfileVM=Get.find();
  FirebaseNotificationsRepo notificationsRepo=Get.find();

  Future<void> sendNotification() async {

    // await notificationsRepo.requestPermission();
  }



}