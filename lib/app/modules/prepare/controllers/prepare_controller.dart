import 'dart:async';

import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/insert_prepare_item_response_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_config_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_item_model.dart';
import 'package:elnozom_pda/app/utils/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PrepareController extends GetxController {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  PrepareConfig config = Get.arguments;
  // inputs controllers
  final codeController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // inputs focus nodes
  final FocusNode itemFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();

  Rx<bool> itemNotFound = false.obs;
  Rx<int> qntRestPart = 0.obs;
  Rx<int> qntRestWhole = 0.obs;
  Rx<String> prevItem = "".obs;
  Rx<String> prevItemMinor = "".obs;
  // Timer? msgsTimer ;
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
  Rx<Item> itemData = Item(
    serial: 0,
    itemName: "0",
    minorPerMajor: 0,
    pOSPP: 0,
    pOSTP: 0,
    byWeight: false,
     i : 0,
    r : 0,
    withExp: false,
    itemHasAntherUnit: false,
    avrWait: 0,
    expirey: "0",
  ).obs;

  final formKey = GlobalKey<FormBuilderState>();
  List<String> columns = [
    "المنتج",
    "السعر",
  ];

  bool msgsDialog = false;

  RxList<PrepareItem> items = PrepareItem.from(Get.arguments.invoice);
  get itemsList => items;
  double prepQnt = 0;

  /// Only relevant for SimplePage at bottom
  void closeDoc() async {
    // msgsTimer!.cancel();
    final Map req = {
      "HSerial": config.hSerial,
      "EmpCode": config.empCode,
    };
    var resp = await DocProvider().closePrepareDoc(req).then((value) {
      if (value == false) {
        Get.offAllNamed('/home');
        Get.snackbar(
          "تحذير",
          "عملية التحضير لم تكتمل و قد تم تعليق المستند",
        );
      } else {
        Get.snackbar(
          "تم",
          "عملية التحضير  اكتملت و قد تم غلق المستند",
        );
        Get.offAllNamed('/home');
      }
    });
  }

 

  
  void itemBcodeReset(context) {
    codeController.text = "";
    itemNotFound.value = true;
    itemData.value = emptyItem;
    // FocusScope.of(context).requestFocus(itemFocus);
  }

  Future scanBarcode(context) async{
    final barcode = BarCode.instance;
    barcode.scanBarcode().then((value) {
      codeController.text = value;
      itemBCodeSubmitted(context , value);
    });
  }
  void itemBCodeSubmitted(context, data) {
    final Map req = {"BCode": data.toString()};
    if (!GlobalController.isNumber(data)) {
      itemBcodeReset(context);
      return;
    }

    DocProvider().getItem(req).then((resp) async {
      prevItem.value = "";
        qntRestWhole.value = 0;
        qntRestPart.value = 0;
      // now we check if we gor response
      if (resp == null) {
        itemBcodeReset(context);
        return;
      }

      // //if we come here that means we have got the item from the server successfully
      //  //check if the item is in the invoice
      final Map validateReq = {
        "ItemSerial": resp.serial,
        'BonSerial': items.value[0].bonSer
      };
      final int validateResp = await DocProvider().isItemInInvoice(validateReq);
      // if resp is equal to 0 that means the item is not into this invoice
      if (validateResp == 0) {
        itemBcodeReset(context);
        return;
      }
      // if resp is equal to 1 that means the item is existed and prepared
      if (validateResp == 1) {
        Get.snackbar("عفوا", "تم تحضير هذا المنتج بالفعل");
        reset(context);
        return;
      }
      // if resp is equal to 2 that means the item is existed in this invoice but we need to insert a part(1)
      if (validateResp == 2) {
        itemData.value = resp;
        itemNotFound.value = false;
        prepQnt = 1;
      }
      // if resp is equal to 3 that means the item is existed in this invoice but we need to insert a whole qnt(Minor Per Major)
      if (validateResp == 3) {
        itemData.value = resp;
        itemNotFound.value = false;
        prepQnt = resp.minorPerMajor.toDouble();
      }
      // fill the data inputs from the server if we got the data from the server
      if (itemData.value.withExp == true) {
        if (itemData.value.expirey != '0') {
          monthController.text = resp.expirey.substring(0, 2);
          yearController.text = resp.expirey.substring(2);
          submit(context);
        } else {
          // FocusScope.of(context).requestFocus(monthFocus);
        }
      } else {
        // if we got here that means we need to submit
        submit(context);
      }
    }, onError: (err) {
      print(err);
    });
    return;
  }


  void getInv(context) {
    var req = {
      "BCode":config.barcode,
    };
    DocProvider().getInv(req).then((resp) {
      config.invoice = resp;
      items.value = resp;
      });
  }
  void submit(context) async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) {
      return;
    }
    //check if item data is not set
    if (itemData.value == emptyItem) {
      itemBCodeSubmitted(context, codeController.text);
      return;
    } else {
      insertItem(context);
    }

    loadMsgs(context);
  }

  void insertItem(context) {
    Map req = {
      "QPrep": prepQnt,
      "ISerial": itemData.value.serial,
      "HSerial": config.hSerial,
      "EmpCode": config.empCode
    };
    DocProvider().insertPrepareItem(req).then((resp) {
      if (resp != null) {
        if(resp.headPrepared == true){
          closeDoc();
        }
        prevItem.value = itemData.value.itemName;
        double qntRest = resp.qnt - resp.qntPrepared;
        double  minor = itemData.value.minorPerMajor.toDouble();
        qntRestWhole.value = (qntRest / minor).floor();
        double wholeDouble = qntRestWhole.value.toDouble();
        qntRestPart.value = qntRest.remainder(minor).toInt();
        itemNotFound.value = false;
        reset(context);
      }
    });
  }

  void reset(context) {
    itemData.value = emptyItem;
    codeController.clear();
    monthController.clear();
    yearController.clear();
    itemFocus.unfocus();
    monthFocus.unfocus();
    yearFocus.unfocus();
    FocusScope.of(context).requestFocus(itemFocus);
  }

  Future<void> showBackAlertDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تحذير'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('هل انت متاكد من انك تريد مغادرة عملية التحضير'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('خروج'),
              onPressed: () {
                Get.offAllNamed('/home');
              },
            ),
            TextButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  DataRow generateRows(rec) {
    List<DataCell> wid = [];
    var wholQnt = (rec.qnt / rec.minorPerMajor).floor().toString();
    var qnt = (rec.qnt.remainder(rec.minorPerMajor)).toString();
    var wholQntPrepared = (rec.qntPrepare / rec.minorPerMajor).floor().toString();
    var qntPrepared = (rec.qntPrepare.remainder(rec.minorPerMajor)).toString();
    var color = rec.isPrepared ? Colors.green : Colors.red;
    wid.add(DataCell(
        Text(
            '${rec.itemName}  \n المحتوي :  ${rec.minorPerMajor} \n الكمية الفعلية :  [جزئي : ${qnt}] / [كلي: ${wholQnt}]  \n كمية التحضير : [جزئي : ${qntPrepared}] / [كلي: ${wholQntPrepared}] ',
            style: TextStyle(color: color)),
            
      ));
    wid.add(DataCell(Text(rec.price.toStringAsExponential(3), style: TextStyle(color: color))));

    return DataRow(
      cells: wid,
    );
  }

  void showMsgsDialog(context, List<dynamic> msgs) async {
    if (msgs == null) {
      msgsDialog = false;
      return;
    } else {
      msgsDialog = true;
      return showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(' قد تلقيت رسالة من متلقي الطلب '),
              content: SingleChildScrollView(
                child:
                    ListBody(children: msgs.map((msg) => Text(msg)).toList()),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('خروج'),
                  onPressed: () {
                    msgsDialog = false;
                    readMsgs(context);
                    Get.offAllNamed('/home');
                  },
                ),
                TextButton(
                  child: const Text('الغاء'),
                  onPressed: () {
                    readMsgs(context);
                    msgsDialog = false;
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  void loadMsgs(context) {
    Map data = {
      "EmpSerial": config.empCode,
      "BonSerial": config.invoice[0].bonSer
    };
    DocProvider().getMsgs(data).then((value) {
      if (value != null && !msgsDialog) {
        showMsgsDialog(context, value);
      }
    });
  }

  void readMsgs(context) {
    Map data = {
      "EmpSerial": config.empCode,
      "BonSerial": config.invoice[0].bonSer
    };
    DocProvider().readMsgs(data);
  }

  void getMsgs(context) {
    loadMsgs(context);
    // msgsTimer = Timer.periodic(new Duration(minutes: 1), (timer) {
    //   print('getMsgs');
    // });
  }

  @override
  void onInit() {
    super.onInit();
    getMsgs(key.currentContext);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // msgsTimer!.cancel();
  }
}
