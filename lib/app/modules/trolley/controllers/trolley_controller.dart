import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TrolleyController extends GetxController with StateMixin<List<dynamic?>> {
  //TODO: Implement TrolleyController
  bool itemNotFound = false;
  final FocusNode itemFocus = FocusNode();
  List<dynamic>? item = [];
  final codeController = TextEditingController();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.success());
  }

  void itemChanged(context, data) {
    final Map req = {"BCode": data.toString(), "StoreCode": 1};
    itemFocus.unfocus();

  

    DocProvider().getTrolleyItem(req).then((resp) {
      item = resp;
      
      if (resp == null) {
        itemNotFound = true;
        codeController.text = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(itemFocus);
        });
        change(null, status: RxStatus.success());
      } else {
        itemNotFound = false;
       
        codeController.text = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(itemFocus);
        });
        change(item, status: RxStatus.success());
      }
    }, onError: (err) {
       codeController.text = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(itemFocus);
        });
      change(null, status: RxStatus.error(err));
    });
    // FocusScope.of(context).requestFocus(itemFocus);
  }

  @override
  void onClose() {}
  void increment() => count.value++;
  
}
