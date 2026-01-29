import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:layouts_flutter/view_model/UserProfile_vm.dart';

import '../../repos/notifications_repo.dart';
import '../../view_model/notifications_vm.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(child: Center(
        child: Text("This is the notifications screen"),
      )),
    );
  }
}


class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
Get.lazyPut(() => NotificationsVM());
Get.lazyPut(() => UserProfileVM());
Get.lazyPut(() => FirebaseNotificationsRepo.instance());
  }

}
