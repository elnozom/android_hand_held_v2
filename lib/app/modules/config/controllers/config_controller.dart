import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/acc_provider.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ConfigController extends GetxController with StateMixin<List<Store>> {
  // inputs controllers & data
  final accBCode = TextEditingController();
  int? accountCode;
  int? accountSerial;

  //TODO: Implement ConfigController
  Config config = Get.arguments;
  final formKey = GlobalKey<FormBuilderState>();

  //this is last character we loaded the data from the server for autocomplete input
  String? lastAccountSearchChar;
  // this is the suggestions list
  List<Acc> accountSuggestions = [];
  // this is the selected account name to how if we loaded the data from the bard code
  String accountName = "";

  // hide the account barcode only if we are in the transaction
  // so this value must be "true" until the trSerial of the config be 27(transactions trSerial)
  bool showAccBarcode = Get.arguments.trSerial != 27;

  // show the invoice barcode only if we are on the sales order
  // so this value must be "false" until the trSerial of the config be 102(salesOrder trSerial)
  bool showAccSearch = false;
  String showSearchText = 'اظهار حقل البحث عن الحساب';

  // show the toStore select box only if we are on the transactions
  // so this value must be "false" until the trSerial of the config be 27(transactions trSerial)
  bool showToStore = Get.arguments.trSerial == 27;

  // this will be true if we called the server with barcode entered by the use and got nothing
  bool noAccFound = false;

  List<Store> stores = [];
  List<DropdownMenuItem<Store>> storesDropdownItems = [];
  //create the new document after loading the data from the inputs
  void create() async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {
      // print(accBCode.text);
      //check if we loaded the account from the server

      if (accountSerial == null) {
        if (accBCode.text != "") {
          accBCodeSubmitted(accBCode.text, true);
        }
      } else {
        config.accSerial = accountSerial;
        // that means if we are on sales order page
        if (config.trSerial == 102) {
          Get.toNamed('/orders', arguments: config);
        } else {
          Get.toNamed('/edit', arguments: config);
        }
      }
    } else {
      print("validation failed");
    }

    change(null, status: RxStatus.success());
  }

  Future<List<Acc?>> searchAccs(String search) async {
    // check if use just added the first char to search
    // check if this char is not the last char we searched for
    // so now we know that the input has only one char and this char is not our last one
    // so now we need to call the server to load all account have this letter
    if (search.length == 1 && search != lastAccountSearchChar) {
      lastAccountSearchChar = search;
      accountSuggestions = await GlobalController()
          .loadAccountsAutcomplete(search, config.accType);

      // check if we already loaded the accounts from the server so we search
      // here we make a clone of our suggestions to not corrubt the original one
      // so if the user deleted the letter and start typing again everthing will work well
    } else {
      List<Acc> filteredAccountSuggestions = accountSuggestions
          .where((item) =>
              item.accountName.toLowerCase().contains(search.toLowerCase()) ||
              item.accountCode
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()))
          .toList();

      return filteredAccountSuggestions;
    }
    return accountSuggestions;
  }

  void accountAutocompleteSaved(data) {
    accountCode = data.accountCode;
    accountSerial = data.serial;
    accountName = data.accountName;
    accBCode.text = accountCode.toString();
    create();
  }

  void toggleShowSearchAcc() {
    showAccSearch = !showAccSearch;
    showSearchText = showAccSearch
        ? 'اخفاء حقل البحث عن الحساب'
        : 'اظهار حقل البحث عن الحساب';
    change(null, status: RxStatus.success());
  }

  // this function will be executed when the user hit enter on the barcode input
  // we want to chek if we are creatint prepare document then we make sure to load employee
  void accBCodeSubmitted([data, bool isFromSubmit = false]) {
    // first we validate the
    // if request is valid then declare the request var
    // send the request to the server
    // check if not found
    // set the account name to one from the server
    if (formKey.currentState!.validate()) {
      var req = {"Code": int.parse(data), "Name": "", "Type": config.accType};
      AccProvider().getAccount(req).then((resp) {
        noAccFound = resp == null || resp.isEmpty;
        if (!noAccFound) {
          accountName = resp.first.accountName;
          accountSerial = resp.first.serial;
          if (isFromSubmit) {
            create();
          }
        }
        change(null, status: RxStatus.success());
      }, onError: (err) {
        noAccFound = true;
        change(null, status: RxStatus.error(err));
      });
    }
  }

  void toStoreChanged(Store? data) {
    config.toStore = data!.storeCode;
    Get.toNamed('/edit', arguments: config);
  }

  void loadStores() async {
    await GlobalProvider().getStores().then((resp) {
      // print(resp);
      stores = resp;
      storesDropdownItems = stores.map((Store store) {
        return DropdownMenuItem(
          value: store,
          child: Text('${store.storeName}'),
        );
      }).toList();
      change(null, status: RxStatus.success());
    });
  }

  void onInit() async {
    accBCode.text = "";
    // Simulating obtaining the user name from some local storage
    super.onInit();
    change(null, status: RxStatus.success());

    //check if we are creating a trnansaction to load the stores
    if (config.trSerial == 27) {
      loadStores();
    }
  }

  void onClose() {
    accBCode.clear();
  }

  void onChanged(data) {
    print(data);
  }
}
