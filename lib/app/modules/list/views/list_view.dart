import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/list_controller.dart';

class ListView extends GetView<ListController> {
  @override
  Widget build(BuildContext context) {
    controller.getDocs();
    return new WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home', arguments: Get.arguments);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('المستندات المفتوحة'),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () => {controller.createDoc()},
                icon: Icon(Icons.add),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: Container(
              alignment: Alignment.topCenter,
              child: Obx(() {
                if (controller.ordersList[0].docNo == "-1" &&
                        controller.isOrder ||
                    controller.docsList[0].docNo == -1 &&
                        !controller.isOrder) {
                  return noItems(controller);
                } else {
                  if (controller.isOrder) {
                    List<String> cols = List.from(controller.columns);
                    cols.add("رقم الحساب");
                    return viewItemsTable(controller.ordersList, cols , controller );
                  } else {
                    List<String> cols = List.from(controller.columns);
                    cols.add("تعديل");
                    return viewItemsTable(controller.docsList, cols ,controller );
                  }
                }
              }),
            ),
          ),
        ));
  }
}

Widget viewItemsTable(list, columns ,controller) {
  return DataTable(
    columns: GlobalController().generateColumns(columns),
    rows: <DataRow>[
      for (var i = 0; i < list.length; i++) controller.generateRows(list[i]),
    ],
  );
}

Widget noItems(controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Text('لا يوجد مستندات مفتوحة'),
        ElevatedButton(
          onPressed: () {
            controller.createDoc();
          },
          child: Text(
            "اضافة مستند جديد",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    ),
  );
}
