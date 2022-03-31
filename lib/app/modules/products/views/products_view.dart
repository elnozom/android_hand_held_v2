import 'package:elnozom_pda/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Get.offAllNamed('/home');
        return true;
      },
      child: Obx(() => controller.loading.value ? LoadingWidget() : Scaffold(
          appBar: AppBar(
              title: Text("اضافة صنف"),
              centerTitle: true,
              bottom: TabBar(
                controller: controller.tabController,
                // controller: tablsController,
                tabs: [
                  Tab(text: 'بيانات الصنف'),
                  Tab(text: 'الاسعار'),
                ],
                onTap: (index) {
                  if (index == 1) {
                    FocusScope.of(context).unfocus();
                  }
                },
              )),
          body: Padding(
            padding: EdgeInsets.all(8),
            child: TabBarView(
              controller: controller.tabController,
              children: [
                
                SingleChildScrollView(
                    child: FormBuilder(
                        key: controller.infoFormKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Column(
                            children: controller.products
                                .basicInfoFormWidget(context)))),
                
                    SingleChildScrollView(
                        child: Column(
                          children: [
                            FormBuilder(
                                key: controller.infoFormKey,
                                autovalidateMode: AutovalidateMode.disabled,
                                child: Column(
                                    children: controller.products
                                        .priceingFormWidget(context))),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    "حفظ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => {controller.createInfo()},
                                ),
                              ),
                            ),
                          ],
                           
                        )),
                     
                  
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
