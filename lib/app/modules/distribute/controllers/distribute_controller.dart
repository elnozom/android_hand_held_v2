import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/utils/barcode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class DistributeController extends GetxController  with SingleGetTickerProviderMixin {
  //TODO: Implement DistributeController

  Rx<bool> itemNotFound = false.obs;
  final FocusNode bonFocus = FocusNode();
  final FocusNode empFocus = FocusNode();
  RxList<dynamic> item = [].obs;
  RxList<dynamic> items = [].obs;
  RxList<dynamic> activeItems = [].obs;
  RxList<dynamic> emp = [].obs;
  Rx<bool> empNotFound = false.obs;
  Rx<bool> selectBon = false.obs;
  Rx<bool> selectDriver = false.obs;
  final bonCodeController = TextEditingController();
  final empCodeController = TextEditingController();
  final count = 0.obs;
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ادخال البون'),
    Tab(text: 'بونات في نفس المنطقة'),
  ];
  TabController? tabController;


  void driverChanged(context, data) {
    GlobalProvider().getEmp(int.parse(data)).then((resp) {
      if (resp == null) {
        emp.value = [];
        empNotFound.value = true;
        return;
      }
      empNotFound.value = false;
      selectDriver.value= false;
      emp.value = resp;
    }, onError: (err) {
      print(err);
    });
  }

  void submit(context) {
    if(item.value.length == 0){
      
        selectBon.value= true;
        Future.delayed(const Duration(milliseconds: 500), () {
            FocusScope.of(context).requestFocus(bonFocus);
          });
        return ;

      
    }
    if(emp.value.length == 0){
     
        selectDriver.value= true;
        Future.delayed(const Duration(milliseconds: 500), () {
            FocusScope.of(context).requestFocus(empFocus);
          });
        return ;
      
    }
    activeItems.add(item[0]['BonSerial']);
    var stringList = activeItems.join(",");
    final Map req = {
      "BonSerial": stringList,
      "DriverCode": int.parse(empCodeController.text),
    };
    DocProvider().updateDriver(req).then((resp) {
      reset(context);
      print(resp);
    }, onError: (err) {
      print(err);
    });
  }


  void reset(context) {
    item = [].obs;
    items = [].obs;
    activeItems = [].obs;
    emp = [].obs;
    bonCodeController.text = '';
    empCodeController.text = '';
     empNotFound = false.obs;
      Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(bonFocus);
        });
  }

  void getBones(context) {
    final Map req = {
      "Area": item[0]['AccountArea'],
      "Serial": item[0]['BonSerial'],
    };
    DocProvider().getAreaDocs(req).then((resp) {
      items.value = resp;
      DefaultTabController.of(context)!.animateTo(1);
    }, onError: (err) {
      print(err);
    });
  }
  Future scanBarcode(context) async{
    final barcode = BarCode.instance;
    barcode.scanBarcode().then((value) {
      bonCodeController.text = value;
      itemChanged(context , value);
    });
  }
  void itemChanged(context, data) {
    bonFocus.unfocus();
    DocProvider().getUnDestributedItem(bonCodeController.text).then((resp) {
      item.value = resp;
      if (resp == null) {
        itemNotFound = true.obs;
        bonCodeController.text = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(bonFocus);
        });
      } else {
        itemNotFound = false.obs;
        selectBon.value= false;
        if(item[0]['BonCount'] > 0){
          getBones(context);
        }
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(empFocus);
        });
      }
    }, onError: (err) {
        itemNotFound = true.obs;
      bonCodeController.text = '';
      Future.delayed(const Duration(milliseconds: 500), () {
        FocusScope.of(context).requestFocus(bonFocus);
      });
    });
    // FocusScope.of(context).requestFocus(itemFocus);
  }

  void appendOrder(serial) {
    activeItems.contains(serial)
        ? activeItems.remove(serial)
        : activeItems.add(serial);
  }

  Container generateRow(dynamic i) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.only(bottom : 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
        color:
            activeItems.contains(i['BonSerial']) ? Colors.blueAccent : Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(children: [
       
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('رقم المستند', textAlign: TextAlign.center)),
            Flexible(
              child: Text(
                i['DocNo'].toString(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(' اسم العميل', textAlign: TextAlign.right)),
            Flexible(
              child: Text(
                i['AccountName'],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('العنوان', textAlign: TextAlign.center)),
            Flexible(
              child: Text(
                i['AccountAddress'],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('اسم المنطقة', textAlign: TextAlign.center)),
            Flexible(
              child: Text(
                item[0]['AreaName'],
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Column generateRows() {
    List<GestureDetector> wid = [];
    for (var i = 0; i < items.value.length; i++) {
      wid.add(GestureDetector(
          onTap: () => {appendOrder(items.value[i]['BonSerial'])},
          child: generateRow(items.value[i])));
    }

    return Column(
      children: wid,
    );
  }
}
