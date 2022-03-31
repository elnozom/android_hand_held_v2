import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/barcode_controller.dart';

class BarcodeView extends GetView<BarcodeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(title: const Text('Barcode scan')),
            body: Builder(builder: (BuildContext context) {
              return Container(
                  alignment: Alignment.center,
                  child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => controller.scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => controller.scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => controller.startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Obx(() => Text('Scan result : ${controller.scanBarcode}\n',
                            style: TextStyle(fontSize: 20)))
                      ]));
            }));
  }
}
