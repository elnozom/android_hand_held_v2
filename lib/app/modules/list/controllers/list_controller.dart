import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/doc_model.dart';
import 'package:elnozom_pda/app/data/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListController extends GetxController {
  //TODO: Implement ListController

  Config config = Get.arguments;
  RxList<Doc> openDocs = [Doc(docNo: -1, accountName: "")].obs;
  get docsList => openDocs;
  final bool isOrder = Get.arguments.trSerial == 101;
  RxList<Order> openOrders = [Order(docNo: "-1", accountName: "", accountCode: -1)].obs;
  get ordersList => openOrders;

  List<String> columns = [
    "رقم",
    "الحساب",
  ];
  @override
  void onInit() async {
    super.onInit();
  }

  // create document request
  // we will load the last doc no from the serve
  // set the last doc to the config struct
  // redirct user to config to load more data if needed
  // or to edit direcxtly to start adding items to doc
  void createDoc() {
    if(config.trSerial == 101){
      Get.toNamed("/prepare-config", arguments: config);
      return;
    }
    final Map docNoReq = {
      "TrSerial": config.trSerial,
    };
    DocProvider().getDocNo(docNoReq).then((resp) {
      // set the doc number on the config struct to pass it to the next view
      // we get that from the api
      config.docNo = resp;
      //check if the type of this tab is -1
      // -1 means that we doc't need to load any other data from the confg view
      // so we go to the edit view to start transaction directly
      if (config.type != -1) {
        Get.toNamed("/config", arguments: config);
      } else {
        Get.toNamed("/edit", arguments: config);
      }
    }, onError: (err) {
      print(err);
    });
  }

  // get items is the function that loads the items from the server
  // it depends on the transaction serial from the config struct
  // sends the request to the server and load the data
  // changes the state of the view to list of docs
  void getDocs() async {
    if (isOrder) {
      // load the unprepared orders from the server
      DocProvider().getUnpreparedDocs().then((resp) {
        if(resp != null && resp.isNotEmpty) openOrders.value = resp;
      }, onError: (err) {
        print(err);
      });
    } else {
      // load normal docs
      final Map req = {"trSerial": config.trSerial};
      DocProvider().getDocs(req).then((resp) {
        if(resp.isNotEmpty){
          openDocs.value = resp;
        }
      }, onError: (err) {
        print(err);
      });
    }
  }

  // edit document function takes doc
  // set the config to the this doc data
  // redirect to edit view
  void editDoc(Doc doc) {
    config.docNo = doc.docNo;
    config.accSerial = doc.accontSerial;
    Get.toNamed("/edit", arguments: config);
  }

  // generates the rows of table
  // this function tatkes instance of doc
  // first will add the doc no
  // set account and check if there is no account to this document
  // then finally push the edit button
  DataRow generateRows(doc) {
    List<DataCell> wid = [];
    wid.add(DataCell(Text(doc.docNo.toString())));
    String txt = doc.accountName == '0' ? 'لا يوجد حساب' : '${doc.accountName}';
    wid.add(DataCell(Text(txt)));
    !isOrder ? wid.add(DataCell(
        TextButton(onPressed: () => {editDoc(doc)}, child: Text('تعديل')))) :
         wid.add(DataCell(Text(doc.accountCode.toString()))) ;
    return DataRow(
      cells: wid,
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
