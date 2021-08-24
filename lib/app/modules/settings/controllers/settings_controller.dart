import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController  with StateMixin<List<Store>> {
  //TODO: Implement SettingsController

  ConfigCache config = ConfigCache();
  List<Store> stores = [];
  final deviceController = TextEditingController();
  final serverController = TextEditingController();
  List<DropdownMenuItem<int>> storesDropdownItems = [];
  final formKey = GlobalKey<FormBuilderState>();

  int? selectedOption ;
  @override
  void onInit() async {
    super.onInit();
    
      config = await GlobalController().getConfigCache();
    GlobalProvider().getStores().then((resp) {
      stores = resp;
      storesDropdownItems = stores.map((Store store) {
        return DropdownMenuItem(
          value: store.storeCode,
          child: Text('${store.storeName}'),
        );
      }).toList();
    selectedOption = config.store;
    deviceController.text = config.device.toString();
    serverController.text = config.server.toString();
     change(resp, status: RxStatus.success());
    }, onError: (err) {
     change(null, status: RxStatus.error(err.toString()));
    });
  }

  void storeChanged(data) {
    selectedOption = data;
  }

  void submit() async {
      final prefs = await SharedPreferences.getInstance();
    if (!formKey.currentState!.validate()) {
      return ;
    } else {
      int device =int.parse(deviceController.text);
      String server = serverController.text;
      prefs.setInt("store", selectedOption!);
      prefs.setInt("device", device);
      prefs.setString("server", server);
      formKey.currentState!.save();
      Get.offAllNamed("/home");
    }
    print(prefs.getInt("device"));
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  
}
