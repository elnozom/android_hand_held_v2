import 'package:elnozom_pda/app/data/acc_provider.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalController extends GetxController {
// the autcomplete suggestion for the account
// and the last charachter to search on this field
// and the flag to check if there is no accs
  List<Acc> accountSuggestions = [];
  List<Item> itemSuggestions = [];
  String? lastAccountSearchChar;
  bool noAccsFound = false;
  bool noItemsFound = false;

// load the meta from cache
  Future<ConfigCache> getConfigCache() async {
    final prefs = await SharedPreferences.getInstance();
    final store = prefs.getInt('store') == null ? 1 : prefs.getInt('store');
    final device = prefs.getInt('device') == null ? 1 : prefs.getInt('device');
    final server = prefs.getString('server') == null
        ? "http://192.168.1.40:8585/api/"
        : prefs.getString('server');

    ConfigCache config =
        ConfigCache(device: device, store: store, server: server);

    return config;
  }

// reset the meta in cahce
  Future<void> resetConfigCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('device') == null) await prefs.setInt('device', 1);
    if (prefs.getInt('store') == null) await prefs.setInt('store', 1);
    if (prefs.getString('server') == null)
      await prefs.setString('server', "http://192.168.1.40:8585/api/");
  }

  //validations
  List<String? Function(String?)> loadConfigBarCodeValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 1,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من صفر'),
    ];

    return bCodeValidatores;
  }

  static bool isNumber(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  // load item qnt is function to call when i need to calculate the qnt 
  // which will passed to the server from whole and part qnt inputs entered by user
  // it depends on is item by weight  or not 
  //  and depend on minor per major
  static double loadItemQnt(bool byWeight ,double whole ,double part ,double minor){
    double qnt;
    if (byWeight) {
      qnt = whole;
    } else {
      qnt = whole * minor +part;
    }

    return qnt;
  }

  List<String? Function(String?)> loadConfigEmpBarCodeValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 0,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من صفر'),
    ];

    return bCodeValidatores;
  }

  List<String? Function(String?)> loadQntValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 0,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من صفر'),
      FormBuilderValidators.max(context, 1000,
          errorText: 'هذا الحقل لا بد ان يكون اصغر من 1000'),
    ];

    return bCodeValidatores;
  }

  List<String? Function(String?)> loadDeviceValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 1,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من صفر'),
      FormBuilderValidators.max(context, 1000,
          errorText: 'هذا الحقل لا بد ان يكون اصغر من 1000'),
    ];

    return bCodeValidatores;
  }

  List<String? Function(String?)> loadServerValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
    ];

    return bCodeValidatores;
  }

  List<String? Function(String?)> loadMonthValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 1,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من صفر'),
      FormBuilderValidators.max(context, 12,
          errorText: 'هذا الحقل لا بد ان يكون اصغر من 12'),
    ];

    return bCodeValidatores;
  }

  List<String? Function(String?)> loadYearValidators(context) {
    var bCodeValidatores = [
      FormBuilderValidators.required(context, errorText: 'هذا الحقل اجباري'),
      FormBuilderValidators.numeric(context,
          errorText: 'هذا الحقل لا بد ان يكون رقم'),
      FormBuilderValidators.min(context, 21,
          errorText: 'هذا الحقل لا بد ان يكون اكبر من 21'),
      FormBuilderValidators.minLength(context, 2,
          errorText: 'هذا الحقل لا بد ان يكون اكبر مكون من رقمين'),
      FormBuilderValidators.max(context, 30,
          errorText: 'هذا الحقل لا بد ان يكون اصغر من 30'),
    ];

    return bCodeValidatores;
  }

  // search the account for the account autocomplete field
  Future<List<Acc>> loadAccountsAutcomplete(String search, accType) async {
    var req = {"Code": 0, "Name": search, "Type": accType};
    await AccProvider().getAccount(req).then((resp) {
      // set the no accounts flag
      // check if response is  null or empty to set it as true
      // if any of the both isnt true then we set it as false
      noAccsFound = resp == null || resp.isEmpty;
      // check  if tthe response has dat
      if (!noAccsFound) {
        accountSuggestions = resp;
      }
    }, onError: (err) {
      noAccsFound = true;
    });

    return accountSuggestions;
  }

  // search products for the product autocomplete field on orders page
  Future<List<Item>> loadProductsAutcomplete(String search) async {
    
    var req = {"Name": search};
    await DocProvider().searchItem(req).then((resp) {
      // set the no accounts flag
      // check if response is  null or empty to set it as true
      // if any of the both isnt true then we set it as false
      noItemsFound = resp == null || resp.isEmpty;
      // check  if tthe response has data
      if (!noItemsFound) {
        itemSuggestions = resp;
      }
    }, onError: (err) {
      noItemsFound = true;
    });

    return itemSuggestions;
  }

  List<DataColumn> generateColumns(columns) {
    List<DataColumn> wid = [];
    for (var i = 0; i < columns.length; i++) {
      wid.add(DataColumn(
        label: Text(
          columns[i],
        ),
      ));
    }
    return wid;
  }
}
