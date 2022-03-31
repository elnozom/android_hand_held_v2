import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/tab_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
// import 'package:imei_plugin/imei_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/data/models/store_model.dart';

class HomeController extends GetxController {
  Rx<bool> loading = true.obs;
  final List<TabModel> tabs = [
    TabModel(
      icon: Icons.add_shopping_cart,
      text: "مشتريات",
      transSerial: 19,
      link: "buy",
      accountType: 2,
      type: 2,
    ),
    TabModel(
      icon: Icons.production_quantity_limits,
      text: 'مرتجع مشتريات',
      transSerial: 26,
      link: 'buy-return',
      accountType: 2,
      type: 2,
    ),
    TabModel(
      icon: Icons.add_shopping_cart,
      text: "المنتجات",
      transSerial: -2,
      link: "products",
      accountType: 0,
      type: 0,
    ),
    TabModel(
      icon: Icons.credit_score,
      text: 'مبيعات',
      transSerial: 30,
      link: 'sell',
      accountType: 1,
      type: 1,
    ),
    TabModel(
      icon: Icons.credit_card,
      text: ' مرتجع مبيعات',
      transSerial: 20,
      link: 'sell-return',
      accountType: 1,
      type: 1,
    ),
    TabModel(
      icon: Icons.cloud_upload_outlined,
      text: ' صرف تحويلات ',
      transSerial: 27,
      link: 'transaction',
      accountType: -1,
      type: 3,
    ),
    TabModel(
      icon: Icons.account_balance_wallet_outlined,
      text: ' رصيد اول مدة',
      transSerial: 24,
      link: 'first',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.check_circle_outline,
      text: 'مراجعة اسعار',
      transSerial: -1,
      link: 'trolley-check',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.inventory_2_outlined,
      text: 'ادوات الجرد',
      transSerial: 31,
      link: 'inventory',
      accountType: -1,
      type: -1,
    ),
    
    TabModel(
      icon: Icons.inventory_2_outlined,
      text: 'مستندات تحضير',
      transSerial: 101,
      link: 'notPrepared',
      accountType: -1,
      type: -1,
    ),
    TabModel(
      icon: Icons.inventory_2_outlined,
      text: 'توزيع',
      transSerial: 102,
      link: 'distribution',
      accountType: 0,
      type: -1,
    ),
    // TabModel(
    //   icon: Icons.inventory_2_outlined,
    //   text: 'امر بيع',
    //   transSerial: 102,
    //   link: 'salesOrder',
    //   accountType: 1,
    //   type: 1,
    // ),
    TabModel(
      icon: Icons.settings_outlined,
      text: "الاعدادات",
      transSerial: 0,
      link: 'settings',
      accountType: -1,
      type: -1,
    )
  ];

  void goTo(index) {
    // init();
  
    // return;
    var tab = tabs[index];
    Config arguments = new Config(
        trSerial: tab.transSerial,
        type: tab.type,
        accType: tab.accountType,
        sessionNo: 0);

    if (tab.transSerial == -2) {
      Get.toNamed("/products");
      return;
    }
    if (tab.transSerial == -1) {
      Get.toNamed("/trolley");
      return;
    }

    if (tab.transSerial == 0) {
      Get.toNamed("/settings");
      return;
    }
    DocProvider().isInventory().then((resp) {
      // prepare

      // inventory
      if (tab.transSerial == 31) {
        if (resp == null) {
          Get.snackbar(
            "عفوا",
            "لا توجد فترة جرد مفتوحة من فضلك تاكد من فتح فترة جرد",
          );
          return;
        } else {
          arguments.sessionNo = resp['SessionNo'];
          arguments.partInv = resp['PartInv'];
          Get.toNamed('/list', arguments: arguments);
        }
      } else {
        if (resp != null && !resp['PartInv']) {
          Get.snackbar(
            "عفوا",
            " توجد فترة جرد مفتوحة  لايمكنك عمل اي حركات في الوقت الحالي",
          );
          return;
        } else {
          if (tab.transSerial == 102) {
            print("asdasd");
            Get.toNamed("/distribute", arguments: arguments);
            return;
          } else {
            Get.toNamed("/list", arguments: arguments);
          }
        }
      }
    }, onError: (err) {
      Get.toNamed("/serverdown");
    });
    // trolley check

    // rest
  }

  Future<void> init() async {
    GlobalProvider().checkDevice().then((int valid) async {
      // if (valid == 0) {
      //   Get.toNamed("/unauthorized");
      // } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt("device", valid);
        print(valid);
        loading.value = false;
      // }
    } , onError: (err){
       Get.toNamed("/serverdown");
    });
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
