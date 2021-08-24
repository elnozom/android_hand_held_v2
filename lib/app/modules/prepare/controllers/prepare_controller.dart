import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/doc_item_model.dart';
import 'package:elnozom_pda/app/data/models/insert_prepare_item_response_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_config_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PrepareController extends GetxController {

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




  Item emptyItem =  Item(
    serial : 0,
    itemName : "0",
    minorPerMajor : 0,
    pOSPP : 0,
    pOSTP : 0,
    byWeight : false,
    withExp : false,
    itemHasAntherUnit : false,
    avrWait : 0,
    expirey : "0",
  );
  //this is the item from the serve
  Rx<Item> itemData = Item(
    serial : 0,
    itemName : "0",
    minorPerMajor : 0,
    pOSPP : 0,
    pOSTP : 0,
    byWeight : false,
    withExp : false,
    itemHasAntherUnit : false,
    avrWait : 0,
    expirey : "0",
  ).obs;

  final formKey = GlobalKey<FormBuilderState>();
  List<String> columns = [
    "المنتج",
    "السعر",
  ];

  RxList<PrepareItem> items = PrepareItem.from(Get.arguments.invoice);
  get itemsList => items;
  double prepQnt = 0;

  /// Only relevant for SimplePage at bottom
  void closeDoc() async {
    final Map req = {
      "HSerial": config.hSerial,
      "EmpCode": config.empCode,
    };
    
    // print(req);
    var resp = await DocProvider().closePrepareDoc(req).then((value) {
      print(value == false);
      if(value == false){
        Get.offAllNamed('/home');
        Get.snackbar(
            "تحذير",
            "عملية التحضير لم تكتمل و قد تم تعليق المستند",
          );
      } else {
        Get.offAllNamed('/home');
      }
    });

   
  }


  List<bool> itemInInv(rec) {
    bool found = false;
    bool prepared = false;
    int serial = rec.serial;
    
    for (var item in items.value) {
      int itemSerial = int.parse(item.itemSerial);
      if (itemSerial == serial) {
        prepared = item.isPrepared;
        found = true;
        itemData.value = rec;
        itemNotFound.value = false;
        if(!prepared){
          int minor = item.minorPerMajor;
          int qnt = item.qnt;
          // check if the qny is lt minor that means we need to load onluy part
          // and on else we need to load onlu whole [1 whole qnt = minor]
          prepQnt = qnt < minor ? 1 : minor.toDouble();
        }
        break;
      }
    }
    return [found, prepared];
  }

  void itemSubmitted(InsertPrepareItemResp response){
    int serial = itemData.value.serial;
    for (var item in items.value) {
      int itemSerial = int.parse(item.itemSerial);
      if (itemSerial == serial) {
        item.isPrepared = response.prepared;
        item.qntPrepare = response.qntPrepared; 
        break;
      }
    }
  }


  void itemBcodeReset(context){
    codeController.text = "";
    itemNotFound.value = true;
    itemData.value = emptyItem;
    print("Asdasd");
    // FocusScope.of(context).requestFocus(itemFocus);

  }
  void itemBCodeSubmitted(context, data) {
    final Map req = {"BCode": data.toString()};
    if(!GlobalController.isNumber(data)){
      itemBcodeReset(context);
      return;
    }
    DocProvider().getItem(req).then((resp) {
      // now we check if we gor response
      if (resp == null) {
        itemBcodeReset(context);

        return ;
      }
     
      //if we come here that means we have got the item from the server successfully
       //check if the item is in the invoice 
      if(!itemInInv(resp)[0]){
        itemBcodeReset(context);
        return;
      }
      // check if item is already prepared
      if(itemInInv(resp)[1]){
        Get.snackbar(
          "عفوا",
          "تم تحضير هذا المنتج بالفعل"
        );
        reset(context);
        return;
      }
      
      // fill the data inputs from the server if we got the data from the server
      if (itemData.value.withExp == true ) {
        if(itemData.value.expirey != '0'){
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
    } , onError: (err) {
      print(err);
      print("err");
    });
    return ;
  }

  
  void submit(context) async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) {
      return ;
    }
    //check if item data is not set
    if (itemData.value == emptyItem) {
       itemBCodeSubmitted(context, codeController.text);
    }
    

    Map req = {
        "QPrep": prepQnt,
        "ISerial": itemData.value.serial,
        "HSerial": config.hSerial,
        "EmpCode" : config.empCode
      };
      print(req);
      DocProvider().insertPrepareItem(req).then((resp) {
        if (resp != null) {
          itemSubmitted(resp);
          reset(context);
        }
      }); 
  }


  void reset(context){
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
    var wholQnt;
    var qnt;
    wholQnt = (rec.qnt / rec.minorPerMajor).floor().toString();
    qnt = (rec.qnt.remainder(rec.minorPerMajor)).toString();
    var color = rec.isPrepared ? Colors.green : Colors.red;
    wid.add(DataCell(Text(
        '${rec.itemName} \n  الكمية الكلية : ${wholQnt} \n الكمية الجزئية : ${qnt} \n الكمية التي تم تحضيرها : ${rec.qntPrepare}  ',
        style: TextStyle(color: color))));
    wid.add(DataCell(Text('${rec.price}', style: TextStyle(color: color))));

    return DataRow(
      cells: wid,
    );
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
