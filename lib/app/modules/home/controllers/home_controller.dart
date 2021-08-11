import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/app/data/models/store_model.dart';
class HomeController extends GetxController with StateMixin<int?> {
  int? dev = null;
  final formKey = GlobalKey<FormBuilderState>();
  List<Store> stores = [
   ];

  List<Item> items = [
    Item(
      serial : 1,
      itemName : "asd" ,
      minorPerMajor : 1,
      pOSPP : 12354,
      pOSTP : 12,
      byWeight : false,
      withExp : false,
      itemHasAntherUnit : false ,
      avrWait : 0,
      expirey : "0"
),

Item(
      serial : 1,
      itemName : "asd" ,
      minorPerMajor : 1,
      pOSPP : 12354,
      pOSTP : 12,
      byWeight : false,
      withExp : false,
      itemHasAntherUnit : false ,
      avrWait : 0,
      expirey : "0"
),
  ];
//fetch store number from the cahche
// will retun 1 if null
  Future<int> _getStoreCache() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getInt('store');
    if (store == null) {
      return 1;
    }
    return store;
  }

  //fetch device number from the cahche
// will retun 1 if null
  Future<int> getDeviceCache() async {
    final prefs = await SharedPreferences.getInstance();
    final device = prefs.getInt('device');
    if (device == null) {
      return 1;
    }
    return device;
  }

// reset the meta in chace to
  Future<void> _resetMeta() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('device') != null) await prefs.setInt('device', 1);
    if (prefs.getInt('store') != null) await prefs.setInt('store', 1);
  }


Future<List<Item>> getSuggestions(String pattern) async{
  return items;
}
  // on changed is test function to implement form builder package

  void onChanged(data) {
    print('changed to');
    print(stores[0].storeName);
  }

  // function to load validators
  
  
  List<String? Function(String?)> loadValidators(ctx){
    var bCodeValidatores = [
      FormBuilderValidators.required(ctx),
      FormBuilderValidators.numeric(ctx),
      FormBuilderValidators.max(ctx, 70),
    ];

    return bCodeValidatores;

  }

  @override
  void onInit() async {
    super.onInit();
    _resetMeta();
    dev = await getDeviceCache();
    change(dev, status: RxStatus.success());
  }

  @override
  void onReady() {
    super.onReady();
  }
}
