import 'package:get/state_manager.dart';

class PrepareItem {
  late String bonSer;
  late int qnt;
  late double price;
  late bool isPrepared;
  late double qntPrepare;
  late String itemCode;
  late String groupCode;
  late int minorPerMajor;
  late String itemName;
  late String itemSerial;
  PrepareItem(
      {
      required this.bonSer,
      required this.qnt,
      required this.price,
      required this.isPrepared,
      required this.qntPrepare,
      required this.itemCode,
      required this.groupCode,
      required this.minorPerMajor,
      required this.itemName,
      required this.itemSerial,
    });
  PrepareItem.fromJson(Map<String, dynamic> json) {
    bonSer = json['BonSer'];
    qnt  = json['Qnt'];
    price  = json['Price'] is int ? json['Price'].toDouble() : json['Price'];
    qntPrepare  = json['QntPrepare'] is int ? json['QntPrepare'].toDouble() : json['QntPrepare'];
    isPrepared  = json['IsPrepared'];
    itemCode  = json['ItemCode'];
    groupCode  = json['GroupCode'];
    minorPerMajor  = json['MinorPerMajor'];
    itemName  = json['ItemName'];
    itemSerial  = json['ItemSerial'];
  }

  static RxList<PrepareItem> from(List<PrepareItem> list){
    return list.obs;
  }

  
}
