import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/trolley_controller.dart';

class TrolleyView extends GetView<TrolleyController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('مراجعة اسعار'),
          centerTitle: true,
        ),
        body: controller.obx((state) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.number,
                      focusNode: controller.itemFocus,
                      controller: controller.codeController,
                      onFieldSubmitted: (data) =>
                          {controller.itemChanged(context, data)},
                      decoration: const InputDecoration(labelText: 'ادخل كود '),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    if (controller.itemNotFound) Text('لا يوجد صنف بهئا الكود'),
                    controller.item != null && controller.item!.isNotEmpty
                        ? Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text('الاسم',
                                          textAlign: TextAlign.center)),
                                  Flexible(
                                    child: Text(
                                      controller.item![0]['ItemName'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text('المحتوي',
                                          textAlign: TextAlign.center)),
                                  Flexible(
                                    child: Text(
                                      controller.item![0]['MinorPerMajor']
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text(' السعر الجزئي',
                                          textAlign: TextAlign.right)),
                                  Flexible(
                                    child: Text(
                                      '${controller.item![0]['POSPP'].toString()} EGP',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text('السعر الكلي',
                                          textAlign: TextAlign.center)),
                                  Flexible(
                                    child: Text(
                                      '${controller.item![0]['POSTP'].toString()} EGP',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                      child: Text('بالوزن',
                                          textAlign: TextAlign.center)),
                                  Flexible(
                                    child: controller.item![0]['ByWeight']
                                        ? Text('نعم',
                                            textAlign: TextAlign.center)
                                        : Text('لا',
                                            textAlign: TextAlign.center),
                                  ),
                                ],
                              ),
                            ]),
                          )
                        : Text(""),
                  ],
                ),
              ),
            )));
  }
}
