import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/distribute_controller.dart';

class DistributeView extends GetView<DistributeController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Get.offAllNamed('/home');
        return true;
      },
      child: Scaffold(
          body: DefaultTabController(
        length: controller.myTabs.length,
        child: Scaffold(
          appBar: AppBar(
              title: Text('توزيع بونات'),
              centerTitle: true,
              bottom: TabBar(
                tabs: controller.myTabs,
                onTap: (index) {
                  if (index == 1) {
                    FocusScope.of(context).unfocus();
                  }
                },
              )),
          body: TabBarView(
            controller: DefaultTabController.of(context),
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        focusNode: controller.bonFocus,
                        controller: controller.bonCodeController,
                        onFieldSubmitted: (data) =>
                            {controller.itemChanged(context, data)},
                        decoration:
                            const InputDecoration(labelText: 'ادخل كود البون '),
                      ),
                       Obx(() {
                        // return Text(controller.itemNotFound.value.toString());
                        if (controller.itemNotFound.value) {
                          return Center(child: Text(" لا يوجد بون بهذا الكود"));
                        } else {
                          return SizedBox(height: 10);
                        }
                      }),
                       Obx(() {
                        if (controller.selectBon.value == true) {
                          return Center(child: Text("ادخل كود البون"));
                        } else {
                          return SizedBox(height: 0);
                        }
                      }),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        focusNode: controller.empFocus,
                        controller: controller.empCodeController,
                        onFieldSubmitted: (data) =>
                            {controller.driverChanged(context, data)},
                        decoration: const InputDecoration(
                            labelText: 'ادخل كود الطيار '),
                      ),
                      Obx(() {
                        if (controller.selectDriver.value == true) {
                          return Center(child: Text("اختر السائق"));
                        } else {
                          return SizedBox(height: 0);
                        }
                      }),
                      Obx(() {
                        if (controller.emp.value.length > 0) {
                          return Center(child: Text(controller.emp.value[0]['EmpName']));
                        } else if (controller.empNotFound.value == true) {
                          return Center(child: Text("لا يوجد طيار بهذا الكود"));
                        } else {
                          return SizedBox(height: 0);
                        }
                      }),
                     Obx(() {
                        if (controller.item.length > 0 && controller.item[0]['BonCount'] > 0){
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                    "يوجد ${controller.item[0]['BonCount']} مستند بنفس المنطقة"),
                              ),
                                
                              
                            ),
                          );
                        } else {
                          return SizedBox(height: 0,);
                        }
                     }),
                      Obx(() {
                        // return Text(controller.itemNotFound.value.toString());
                        if (controller.item.length > 0) {
                          // return Center(child: Text(" لا يوجد بون بهذا الكود"));
                          return controller.generateRow(controller.item[0]);
                        } else {
                          return SizedBox(height: 10);
                        }
                      }),
                       SizedBox(
                        height: 30,
                      ),
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
                                controller.scanBarcode(context);
                              },
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "توزيع",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              controller.submit(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                              child: Column(
                  children: [
                    Obx(() {
                      // return Text(controller.itemNotFound.value.toString());
                      if (controller.items.value.length > 0) {
                        // return Center(child: Text(" لا يوجد بون بهذا الكود"));
                        return Padding(
                            padding: EdgeInsets.all(8),
                            child: controller.generateRows());
                      } else {
                        return Center(child : Text("لا يوجد بونات اخري في نفس المنطقة"));
                      }
                    }),
                    Obx(() {
                      return controller.activeItems.value.length > 0 ? Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text(
                                  "الغاء الاختيار",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  controller.activeItems.value = [];
                                },
                              ),
                            ),
                          ) : SizedBox(height:0);

                    }),
                    
                    Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                "توزيع",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                controller.submit(context);
                              },
                            ),
                          ),
                        ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      )),
    );
  }
}
