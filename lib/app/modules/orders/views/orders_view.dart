import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/order_item_model.dart';
import 'package:elnozom_pda/widgets/ProductsSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

import '../controllers/orders_controller.dart';

class OrdersView extends GetView<OrdersController> {
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'ادخال الاصناف'),
    Tab(text: 'عرض الاصناف'),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home');
          return true;
        },
        child: Scaffold(
            body: DefaultTabController(
          length: myTabs.length,
          child: Scaffold(
              appBar: AppBar(
                  title: controller.config.accName  != null ? Text(controller.config.accName!) : Text("تعديل المستند"),
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
                      }
                    },
                  )),
              body: TabBarView(children: [
                insert(context, controller),
                Obx(() {
                  // return Text(controller.itemNotFound.value.toString());
                  if (controller.items.value.first.serial == -1) {
                    return Center(child: Text("الا يوجد اصناف"));
                  } else {
                    return viewItemsTable(controller.itemsList, controller);
                  }
                }),
              ])),
        )));
  }
}

Widget viewItemsTable(List<OrderItem> items, controller) {
  return SingleChildScrollView(
    child: Column(
      children: [
        DataTable(
          columns: GlobalController().generateColumns(controller.columns),
          dataRowHeight: 110,
          rows: <DataRow>[
            for (var i = 0; i < items.length; i++)
              controller.generateRows(items[i]),
          ],
        ),
        Divider(),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.spaceAround,
            children: [
              Text("الاجمالي : "),
              Text("${controller.totals.value.totalCash}EGP")
            ],
          );
        })
        
      ],
    ),
  );
}

Widget insert(context, controller) {
  return Container(
    padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          FormBuilder(
              key: controller.formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(children: <Widget>[
                getProductsSearch(context , controller),
                Row(children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'qnt_whole',
                      focusNode: controller.wholeQntFocus,
                      controller: controller.wholeQntController,
                      decoration: InputDecoration(
                        labelText: 'ادخل الكمية الكلية',
                      ),
                      onSubmitted: (data) =>
                          {controller.wholeQntChanged(context, data)},
                      // valueTransformer: (text) => num.tryParse(text),
                      validator: FormBuilderValidators.compose(
                          GlobalController().loadQntValidators(context)),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 10),
                  Obx(() {
                    if (controller.qntHidden.value == false) {
                      return Expanded(
                        child: FormBuilderTextField(
                          name: 'qnt',
                          focusNode: controller.qntFocus,
                          controller: controller.qntController,

                          decoration: InputDecoration(
                            labelText: 'ادخل الكمية الجزئية',
                          ),
                          onSubmitted: (data) =>
                              {controller.qntChanged(context, data)},
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose(
                              GlobalController().loadQntValidators(context)),
                          keyboardType: TextInputType.number,
                        ),
                      );
                    } else {
                      return SizedBox(height: 0);
                    }
                  }),
                ]),
                Obx(() {
                  if (controller.qntErr.value == true) {
                    return Text("من فضلك ادخل كمية");
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                Obx(() {
                  if (controller.itemNotFound.value == true) {
                    return Text("من فضلك اختر المنتج ");
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                Obx(() {
                  if (controller.withExp.value == true &&
                      controller.expExisted.value == false) {
                    return Row(children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'month',
                          focusNode: controller.monthFocus,
                          controller: controller.monthController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'ادخل شهر انتهاء الصلاحية',
                          ),
                          onSubmitted: controller.onChanged,
                          // valueTransformer: (text) => num.tryParse(text),
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
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'ادخل شهر سنة الصلاحية',
                          ),
                          onSubmitted: controller.onChanged,
                          // valueTransformer: (text) => num.tryParse(text),
                          validator: FormBuilderValidators.compose(
                              GlobalController().loadYearValidators(context)),
                          keyboardType: TextInputType.number,
                        ),
                      )
                    ]);
                  } else {
                    return SizedBox(height: 0);
                  }
                }),
                // check if item has expiry and its not passed from the server to show the data inputs

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
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
