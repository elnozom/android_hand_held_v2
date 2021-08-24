import 'dart:convert';

import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/doc_item_model.dart';
import 'package:elnozom_pda/app/data/models/doc_model.dart';
import 'package:elnozom_pda/app/data/models/insert_prepare_item_response_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/order_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_item_model.dart';
import 'package:get/get.dart';

class DocProvider extends GetConnect {
  @override
  String server = "";
  ConfigCache config = ConfigCache();

  Future<int> getDocNo(Map data) async {
    config = await GlobalController().getConfigCache();
    data['DevNo'] = config.device;
    data['StoreCode'] = config.store;
    final response = await post('${config.server}get-doc', data);
    return response.body;
  }
  Future<InsertPrepareItemResp> insertPrepareItem(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}invoice', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return InsertPrepareItemResp.fromJson(response.body[0]);
    }
  }


  Future<List<DocItem>> getItems(Map data) async {
    config = await GlobalController().getConfigCache();
    data['DevNo'] = config.device;
    data['StoreCode'] = config.store;
    final response = await post('${config.server}get-doc-items', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<DocItem> items = [];
      if (response.body != null)
        response.body.forEach((item) {
          DocItem docItem = DocItem.fromJson(item);
          items.add(docItem);
        });
      return items;
    }
  }

  Future<Item?> getItem(Map data) async {
    config = await GlobalController().getConfigCache();
    data['StoreCode'] = config.store;
    final response = await post('${config.server}get-item', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body == null ? null : Item.fromJson(response.body[0]);
    }
  }
   Future<List<Item>> searchItem(Map<String , dynamic> data) async {
    config = await GlobalController().getConfigCache();
    var data2 = {"BCode" : "" , "StoreCode" : config.store! , "Name" : data['Name']};
    final response = await post('${config.server}get-item', data2);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<Item> items = [];
      if(response.body != null) response.body.forEach((res){
        Item item = Item.fromJson(res);
        items.add(item);
      });
      // print(items);
      return items;
    }
  }


  Future<List<dynamic?>> getTrolleyItem(Map data) async {
    config = await GlobalController().getConfigCache();
    data['StoreCode'] = config.store;
    final response = await post('${config.server}get-item', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }

  

  Future<bool> insertItem(Map data) async {
    config = await GlobalController().getConfigCache();
    data['StCode'] = config.store;
    data['DevNo'] = config.device;
    final response = await post('${config.server}insert-item', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return true;
    }
  }

  Future<bool> closeDoc(Map data) async {
    config = await GlobalController().getConfigCache();
    data['DevNo'] = config.device;
    final response = await post('${config.server}close-doc', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return true;
    }
  }
 
   Future<bool> closePrepareDoc(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}invoice/close', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body[0]['Close'];
    }
  }


  
  Future<int?> isInventory() async {
    config = await GlobalController().getConfigCache();
    Map data = {"StoreCode" : config.store};
    final response = await post('${config.server}invenetory' , data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      // print(response.body[0]['SessionNo']);
      return response.body == null ? null : response.body[0]['SessionNo'];
    }
  }

  Future<List<PrepareItem>> getInv(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}invoice?BCode=${data["BCode"]}');
    print(response.body);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<PrepareItem> items = [];
      if (response.body != null)
        response.body.forEach((item) {
          PrepareItem prepareItem = PrepareItem.fromJson(item);
          items.add(prepareItem);
        });
      return items;
    }
  }
  Future<bool> removeDocItem(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}delete-item', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return true;
    }
  }

  Future<List<Doc>> getDocs(Map data) async {
    config = await GlobalController().getConfigCache();
    data['devNo'] = config.device;
    data['stCode'] = config.store;
    final response = await post('${config.server}get-docs', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<Doc> docs = [];
      if (response.body != null)
        response.body.forEach((item) {
          Doc doc = Doc.fromJson(item);
          docs.add(doc);
        });
      return docs;
    }
  }

  Future<List<Order>> getUnpreparedDocs() async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}invoice/open');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<Order> docs = [];
      if (response.body != null)
        response.body.forEach((item) {
          Order doc = Order.fromJson(item);
          docs.add(doc);
        });
      return docs;
    }
  }
}
