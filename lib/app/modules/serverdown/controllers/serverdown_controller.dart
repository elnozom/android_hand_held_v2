import 'dart:async';

import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServerdownController extends GetxController {
  //TODO: Implement ServerdownController
  Rx<bool> loading = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void reload() async {
    loading.value = true;
    GlobalProvider().checkDevice().then((int valid) async {
      if (valid == 0) {
        Get.offAllNamed("/unauthorized");
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt("device", valid);
        loading.value = false;
        Get.offAllNamed("/home");
      }
      Timer(Duration(seconds: 1), () {
        loading.value = false;
      });
    }, onError: (err) {
      Timer(Duration(seconds: 1), () {
        loading.value = false;
      });
    });
  }
}
