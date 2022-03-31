import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/unauthorized_controller.dart';

class UnauthorizedView extends GetView<UnauthorizedController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
              child: Container(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Loader Animation Widget

                Obx(() {
                  return controller.wrongKey.value == true
                      ? Text("لقد ادخلت كود تفعيل غير صحيح")
                      : SizedBox(height: 0);
                }),
                Image.asset(
                  'assets/images/lock.png',
                  width: 150.0,
                  height: 50.0,
                ),
                Text(
                  "يبدو لنا ان الجهاز لم يتم تفعيله بعد علي قواعد بيناتنا لتفعيل الجهاز يرجي التواصل مع الدعم الفني",
                  textAlign: TextAlign.center,
                ),
                Text(
                  ":الرقم التعريفي للجهاز ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(
                    GlobalController().encrypt(controller.key),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                FormBuilder(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(children: <Widget>[
                      // Text(controller.config.partInv.toString()),
                      FormBuilderTextField(
                        name: 'key',
                        controller: controller.keyController,
                        textInputAction: TextInputAction.done,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: 'ادخل كود التفعيل ',
                        ),
                        onSubmitted: (data) => {controller.submit(context)},
                        // valueTransformer: (text) => num.tryParse(text),
                      ),
                      // FormBuilderCheckbox(name: 'common', title: Text("استخدام متعدد") , onChanged:(value) => print(value)),
                      FormBuilderCheckbox(
                        name: 'common',
                        initialValue: true,
                        onChanged: (value) {
                          controller.showEmpCode.value = !(value!);
                        },
                        title: Text("استخدام متعدد"),
                      ),
                      Obx(() {
                        if (controller.showEmpCode.value) {
                          return FormBuilderTextField(
                            name: 'empCode',
                            controller: controller.keyController,
                            textInputAction: TextInputAction.done,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'ادخل كود الموظف ',
                            ),
                            onSubmitted: (data) => {controller.submit(context)},
                            // valueTransformer: (text) => num.tryParse(text),
                          );
                        }
                        return SizedBox(height: 0);
                      }),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              "تفعيل",
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
        ),
      ),
    );
  }
}
