import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import '../controllers/prepare_controller.dart';

class PrepareView extends GetView<PrepareController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          controller.closeDoc();
          // await Get.offAllNamed('/home');
          return true;
        },
        child: Scaffold(
            key: controller.key, body: defaultWid(context, controller)));
  }
}

Widget defaultWid(context, controller) {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ادخال الاصناف'),
    Tab(text: 'عرض الاصناف'),
  ];
  return DefaultTabController(
    length: myTabs.length,
    child: Scaffold(
        appBar: AppBar(
            title: Text('تعديل المستند'),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () => {controller.closeDoc()},
                icon: Text('غلق'),
              )
            ],
            bottom: TabBar(
              tabs: myTabs,
              onTap: (index) {
                if (index == 1) {
                  FocusScope.of(context).unfocus();
                  controller.getInv(context);
                }
              },
            )),
        body: TabBarView(children: [
          insert(context, controller),
          Obx(() {
            return viewItemsTable(controller);
          }),
        ])),
  );
}

Widget viewItemsTable(controller) {
  return SingleChildScrollView(
    child: Column(
      children: [
        DataTable(
          columns: GlobalController().generateColumns(controller.columns),
          dataRowHeight: 220,
          rows: <DataRow>[
            for (var i = 0; i < controller.items.length; i++)
              controller.generateRows(controller.items[i]),
          ],
        ),
      ],
    ),
  );
}

Widget insert(context, controller) {
  final formKey = GlobalKey<FormBuilderState>();
  return Container(
    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(children: <Widget>[
                FormBuilderTextField(
                  name: 'bcode_item',
                  focusNode: controller.itemFocus,
                  controller: controller.codeController,
                  // textInputAction: TextInputAction.none,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'ادخل كود المنتج',
                  ),
                  onSubmitted: (data) =>
                      {controller.itemBCodeSubmitted(context, data)},
                  valueTransformer: (text) => num.tryParse(text),
                  validator: FormBuilderValidators.compose(
                      GlobalController().loadConfigBarCodeValidators(context)),
                  keyboardType: TextInputType.number,
                ),
                Obx(() {
                  // return Text(controller.itemNotFound.value.toString());
                  if (controller.itemNotFound.value == true) {
                    return Text(' لا يوجد صنف بهذا الكود في هذه الفاتورة');
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                Obx(() {
                  if (controller.itemData.value.serial != 0) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.itemData.value.itemName}',
                        ),
                        Text(
                            'المحتوي:${controller.itemData.value.minorPerMajor.toString()}')
                      ],
                    );
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                Obx(() {
                  if(controller.prevItem.value != "") {
                    return Wrap(
                      children: [
                        controller.qntRestPart.value > 0 || controller.qntRestWhole.value > 0
                            ? Text(
                                '${controller.prevItem.value} المتبقي : ${controller.qntRestPart.value} جزئي و ${controller.qntRestWhole.value} كلي')
                            : Text(
                                '${controller.prevItem.value} تم التحضير')
                      ],
                    );
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                Obx(() {
                  return Visibility(
                    visible: controller.itemData.value.withExp == true &&
                        controller.itemData.value.expirey == '0',
                    child: Row(children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'month',
                          focusNode: controller.monthFocus,
                          controller: controller.monthController,
                          autofocus: true,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'ادخل شهر انتهاء الصلاحية',
                          ),
                          validator: FormBuilderValidators.compose(
                              GlobalController().loadMonthValidators(context)),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'year',
                          focusNode: controller.yearFocus,
                          controller: controller.yearController,
                          textInputAction: TextInputAction.go,
                          decoration: InputDecoration(
                            labelText: 'ادخل شهر سنة الصلاحية',
                          ),
                          onSubmitted: (data) => {controller.submit(context)},
                          validator: FormBuilderValidators.compose(
                              GlobalController().loadYearValidators(context)),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ]),
                  );
                }),
                // check if item has expiry and its not passed from the server to show the data inputs
                    Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              child: Text(
                                "قراءة الباركود",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                controller.create(context);
                              },
                            ),
                          ),
                        ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(
                        "حفظ",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        controller.submit(context);
                      },
                    ),
                  ),
                ),
              ]))
        ],
      ),
    ),
  );
}
