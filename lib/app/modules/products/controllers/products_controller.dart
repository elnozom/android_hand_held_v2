import 'package:elnozom_pda/app/data/product_provider.dart';
import 'package:elnozom_pda/app/helpers/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class ProductsController extends GetxController
    with SingleGetTickerProviderMixin {
  //TODO: Implement ProductsController
  final Products products = new Products();
  final ProductProvider provider = new ProductProvider();
  final infoFormKey = GlobalKey<FormBuilderState>();
  final priceFormKey = GlobalKey<FormBuilderState>();
  RxBool loading = true.obs;
  TabController? tabController;
  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 2);
    loading.value = false;
    super.onInit();
  }

  Future createInfo() async {
    infoFormKey.currentState!.save();
    if (!(infoFormKey.currentState!.validate())) {
      print("validation failed");
      return;
    }
    priceFormKey.currentState!.save();
    if (!(priceFormKey.currentState!.validate())) {
      print("validation failed");
      return;
    }
    double disc2 = 0.0;
    if (products.disc2Controller.text != "")
      disc2 = double.parse(products.disc2Controller.text);
    var data = {
      "GroupCode": int.parse(products.itemCodeController.text),
      "ItemCode": int.parse(products.groupCodeController.text),
      "BarCode": products.barCodeController.text,
      "Name": products.nameController.text,
      "MinorPerMajor": int.parse(products.minorController.text),
      "AccountSerial": 1,
      "ActiveItem": products.active,
      "ItemTypeID": 1,
      "ItemHaveSerial": products.hasSerial,
      "MasterItem": products.complex,
      "ItemHaveAntherUint": products.hasAntherUnit,
      "StoreCode": 1,
      "LastBuyPrice": double.parse(products.buyWholeFinalPriceController.text),
      "POSTP": double.parse(products.sellWholePriceController.text),
      "POSPP": double.parse(products.sellPartPriceController.text),
      "Ratio1": double.parse(products.disc1Controller.text),
      "Ratio2": disc2
    };
    await provider.createInfo(data);
    infoFormKey.currentState!.reset();
    priceFormKey.currentState!.reset();
    tabController!.animateTo(1);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
