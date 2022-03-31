import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController with StateMixin<List<Store>> {
  //TODO: Implement SettingsController

  ConfigCache config = ConfigCache();
  List<Store> stores = [];
  final passwordController = TextEditingController();
  final serverController = TextEditingController();
  List<DropdownMenuItem<int>> storesDropdownItems = [];
  final formKey = GlobalKey<FormBuilderState>();
  bool isAuthorized = false;
  bool wrongPassword = false;

  int? selectedOption;
  @override
  void onInit() async {
    super.onInit();
      change(null, status: RxStatus.success());
  }

  void init() async {
      isAuthorized = true;
    final prefs = await SharedPreferences.getInstance();
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
      serverController.text = prefs.getString('server') != null
          ? prefs.getString('server')!
          : "192.168.1.192:8585";
      change(resp, status: RxStatus.success());
    }, onError: (err) {
      change(null, status: RxStatus.error(err.toString()));
    });
  }

  void authorize() {
    if (passwordController.text == '1234') {
      wrongPassword = false;
      init();
    } else {
      wrongPassword = true;
      change(null, status: RxStatus.success());
    }
  }

  void storeChanged(data) {
    selectedOption = data;
  }

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    if (!formKey.currentState!.validate()) {
      return;
    } else {
      String server = serverController.text;
      prefs.setInt("store", selectedOption!); 
      prefs.setString("server", server);
      formKey.currentState!.save();
      Get.offAllNamed("/home");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
