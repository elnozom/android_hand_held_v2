import 'dart:math';

import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:imei_plugin/imei_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnauthorizedController extends GetxController {
  //TODO: Implement UnauthorizedController
  
    final formKey = GlobalKey<FormBuilderState>();
  final keyController = TextEditingController();
  String key = Random().nextInt(999999).toString().padLeft(6, '0');
 Rx<bool> wrongKey = false.obs;
Rx<bool> showEmpCode = false.obs;
  void submit(context) async{
    if(keyController.text == key){
      wrongKey.value = false;
      int deviceNo = await GlobalProvider().insertDevice();
       final prefs = await SharedPreferences.getInstance();
       prefs.setInt("device", deviceNo);
      await Get.offAllNamed('/home');
    } else {
      wrongKey.value = true;
    }
    
  }


  
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
  
}
