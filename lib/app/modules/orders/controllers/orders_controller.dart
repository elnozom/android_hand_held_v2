import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/order_item_model.dart';
import 'package:elnozom_pda/app/data/models/order_totals_model.dart';
import 'package:elnozom_pda/app/data/orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  // inputs controllers
  final itemController = TextEditingController();
  final wholeQntController = TextEditingController();
  final qntController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // inputs focus nodes
  final FocusNode itemFocus = FocusNode();
  final FocusNode qntFocus = FocusNode();
  final FocusNode wholeQntFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();

  Rx<bool> itemNotFound = false.obs;
  Rx<bool> qntErr = false.obs;

  // flag to use on input textInputAction to set to done or next
  Rx<bool> qntWholeIsLastInput = true.obs;
  //inputs checks
  Rx<bool> qntHidden = false.obs;

  String? lastItemSearchChar;
  List<Item> itemSuggestions = [];
  Rx<OrderTotals> totals = OrderTotals(totalPackages: 0, totalCash: 0.0, serial: 0).obs;
  Item emptyItem = Item(
    serial: 0,
    itemName: "0",
    minorPerMajor: 0,
    pOSPP: 0,
    pOSTP: 0,
     i : 0,
    r : 0,
    byWeight: false,
    withExp: false,
    itemHasAntherUnit: false,
    avrWait: 0,
    expirey: "0",
  );
  //this is the item from the serve
  Item itemData = Item(
    serial: 0,
    itemName: "0",
    minorPerMajor: 0,
    pOSPP: 0,
    pOSTP: 0,
     i : 0,
    r : 0,
    byWeight: false,
    withExp: false,
    itemHasAntherUnit: false,
    avrWait: 0,
    expirey: "0",
  );

  // falg to identify that the item is with the expiry data and we can catch ite from the server
  Rx<bool> expExisted = false.obs;
  // falg to identify that the item is with the expiry data or not
  Rx<bool> withExp = false.obs;

  final formKey = GlobalKey<FormBuilderState>();
  Config config = Get.arguments;
  int? headSerial = Get.arguments.headSerial ;
  List<String> columns = [
    "المنتج",
    "الاجمالي",
  ];
  OrderItem emptyOrderItem  = OrderItem(serial: -1, barCode: -1, qntAntherUnit: 0,itemName: '', qnt: 0, price: 0, total: 0);
  RxList<OrderItem> items = [OrderItem(serial: -1, barCode: -1, qntAntherUnit: 0,itemName: '', qnt: 0, price: 0, total: 0)].obs;
  get itemsList => items;

  /// Only relevant for SimplePage at bottom
  void closeDoc() async {
    final Map req = {"Serial": config.headSerial, "TotalCash": 100};
    // print(req);
    await OrdersProvider().closeOrder(req);

    Get.toNamed('/home');
  }

  void itemAutocompleteSaved(context, Item item) {
    // get the with exp fkag to the value from the server
    if( item.withExp ) withExp.value = item.withExp;
    itemData = item;

    // first we set the expexisted to its default value
    // then we check if we can got this from the server
    // then we set the calue of data inputs from our expiry from the server if its there
    expExisted.value = false;
    if (item.withExp) {
      //if expiry is = 0 that means we cant access it from the server
      if (item.expirey != '0') {
        monthController.text = item.expirey.substring(0, 2);
        yearController.text = item.expirey.substring(2);
        expExisted.value = true;
      }
    }
    //check if the minor per mahor is 1
    // that means we dont have any part qnt
    // so we hide its input
    if (item.minorPerMajor == 1) {
      qntController.text = '0';
      qntHidden.value = true;
    } else {
      qntHidden.value = false;
    }

    _fieldFocusChange(context, itemFocus, wholeQntFocus);
  }

  Future<List<Item?>> searchItems(String search) async {
    // check if use just added the first char to search
    // check if this char is not the last char we searched for
    // so now we know that the input has only one char and this char is not our last one
    // so now we need to call the server to load all account have this letter
    if (search.length == 1 && search != lastItemSearchChar) {

      print("searcg");
      lastItemSearchChar = search;
      itemSuggestions =
          await GlobalController().loadProductsAutcomplete(search);

          print(itemSuggestions);

      // check if we already loaded the accounts from the server so we search
      // here we make a clone of our suggestions to not corrubt the original one
      // so if the user deleted the letter and start typing again everthing will work well
    } else {
      List<Item> filteredItemSuggestions = itemSuggestions.where((item) {
        return item.itemName.toLowerCase().contains(search.toLowerCase());
      }).toList();

      // print(filteredItemSuggestions);
      return filteredItemSuggestions;
    }
    return itemSuggestions;
  }

  void submit(context) async {
    print("asdasdasdasd");
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) {
      return;
    }
   
    //check if item data is not set
    if (itemData.itemName == '0') {
      itemNotFound.value = true;
      return;
    } else {
      itemNotFound.value = false;
      // declar the qnt
      // set the value of qntcontroller to = if its not set
      // then check if the item is byweight to set qnt to the whole qnt value
      // if false then we make our calculation as (whole qnt * minor + part qnt)
      // ant then we have the qnt value which will bend send to the server

       
      qntController.text = qntController.text == "" ? '0' : qntController.text;
      final bool byWeight = itemData.byWeight;
      final bool hasAntherUnit = itemData.itemHasAntherUnit;
      final double avgWeight =itemData.avrWait;
      final double whole = double.parse(wholeQntController.text);
      final double part = double.parse(qntController.text);
      final double minor = itemData.minorPerMajor.toDouble();

      List<double> qntList = loadItemQnt(byWeight,hasAntherUnit ,avgWeight, whole, part, minor);
      double qnt = qntList[0];
      double qntAntherUnit = qntList[1];

      // CHECK IF qnt is 0 to show error
      if (qnt == 0) {
        qntErr.value = true;
        return;
      }
      // if we reached  here that means we are loaded the qnt succesflly
      qntErr.value = false;

      // now we set the expDate string as we like to send it to the server
      var expD = monthController.text != ""
          ? '${monthController.text}/1/${yearController.text}'
          : null;
      if (items.value.first.serial == -1) {
        final Map orderReq = {
          "AccountSerial": config.accSerial,
          "EmpCode": 0,
        };
        headSerial = await OrdersProvider().insertOrder(orderReq);
        config.headSerial = headSerial;
      }

      if(qnt == 0) {
         Get.snackbar(
            "عفوا",
            "هذا المنتج لا يحتوي علي متوسط الوزن من فضلك قم باعداده اولا للتمكن من اضافته",
           );
        return ;
      }

     
      final Map itemReq = {
        "HeadSerial": headSerial,
        "ItemSerial": itemData.serial,
        "Qnt": qnt,
        "QntAntherUnit" : qntAntherUnit,
        "Price": itemData.pOSPP,
      };

      var resp = await OrdersProvider().insertOrderItem(itemReq);
      totals.value = resp;
      OrderItem item = OrderItem(itemName: itemData.itemName ,serial: itemData.serial ,barCode: itemData.serial ,qnt: qnt ,qntAntherUnit: qntAntherUnit , price:itemData.pOSPP , total: (itemData.pOSPP * qnt));
      if(items.value.first.serial == -1){
        items.value = [item];
      } else {
        items.value.add(item);
      }

     _reset(context);
     expD = null;
      
      return;
    }
  }

  // load item qnt is function to call when i need to calculate the qnt 
  // which will passed to the server from whole and part qnt inputs entered by user
  // it depends on is item by weight  or not 
  //  and depend on minor per major
  List<double> loadItemQnt(bool byWeight , bool hasAntherUnit, double avgWeight , double whole ,double part ,double minor){
    double qnt = 0;
    double qntAntherUnit = 0.0;
    if (byWeight) {
       if (hasAntherUnit) {
         qntAntherUnit = whole;
       } else {
          qnt = whole;
       }
      
    } else {
      if (hasAntherUnit) {
        qntAntherUnit =  whole * minor +part;
        qnt =  qntAntherUnit * avgWeight;
       } else {
        qnt = whole * minor +part;
       }
    }

    return [qnt , qntAntherUnit];
  }

  _reset(context){
      itemData = emptyItem;
      itemController.clear();
      wholeQntController.clear();
      qntController.clear();
      monthController.clear();
      yearController.clear();
      withExp.value = false;
       var currentInput = qntHidden.value == true ? wholeQntFocus : qntFocus;
      _fieldFocusChange(context, currentInput, itemFocus);
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  DataRow generateRows(OrderItem item) {
    List<DataCell> wid = [];

    
    wid.add(DataCell(Text(
        '${item.itemName} \n  الكمية : ${item.qnt.toString()} \n  السعر : ${item.price.toString()} ')));
    wid.add(DataCell(Text(
        '${item.total} ')));

    return DataRow(
      cells: wid,
    );
  }

  void fetchItems() async {
    if(config.headSerial != null){
      var resp = await OrdersProvider().getOrderItems(config.headSerial!);
      items.value = resp;
    }
    // change(null, status: RxStatus.success());
  }

  void onChanged(data) {
    print(data);
  }

  void wholeQntChanged(context, data) {
    if (!qntHidden.value) {
      _fieldFocusChange(context, wholeQntFocus, qntFocus);
    }
    if (withExp.value && qntHidden.value) {
      _fieldFocusChange(context, wholeQntFocus, monthFocus);
    }

    if (!withExp.value && qntHidden.value) {
      submit(context);
    }
  }

  void qntChanged(context, data) async {
    if (withExp.value && !expExisted.value) {
      _fieldFocusChange(context, qntFocus, monthFocus);
    } else {
      submit(context);
    }
  }

  void monthChanged(context, data) {
    // if(data.length > 2){
    //   dateErr = true;
    // }
    // int intD = int.parse(data);
    // if(intD > 12 || intD <=0){
    //   dateErr = true;
    // }
    _fieldFocusChange(context, monthFocus, yearFocus);
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }
}
