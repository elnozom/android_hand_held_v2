import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Get.offAllNamed('/home');
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text('الاعدادات'),
            centerTitle: true,
          ),
          body: controller.obx(
            (state) => SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: controller.isAuthorized
                      ? FormBuilder(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(children: [
                            FormBuilderDropdown<int>(
                              name: 'store',
                              decoration: InputDecoration(
                                labelText: 'اختر المخزن',
                              ),
                              // initialValue: 'Male',
                              allowClear: true,
                              hint: Text('اختر المخزن'),
                              onChanged: controller.storeChanged,
                              initialValue: controller.selectedOption,
                              items: controller.storesDropdownItems,
                            ),
                            FormBuilderTextField(
                              name: 'server',
                              controller: controller.serverController,
                              decoration: InputDecoration(
                                labelText: 'ادخل عنوان الخادم',
                              ),
                              textInputAction: TextInputAction.next,
                              // valueTransformer: (text) => num.tryParse(text),
                              validator: FormBuilderValidators.compose(
                                  GlobalController()
                                      .loadServerValidators(context)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  child: Text(
                                    "حفظ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    controller.submit();
                                  },
                                ),
                              ),
                            ),
                          ]),
                        )
                      : Column(children: [
                          FormBuilderTextField(
                            obscureText:true,
                            name: 'password',
                            controller: controller.passwordController,
                            decoration: InputDecoration(
                              labelText: 'ادخل كلمة السر',
                            ),
                            textInputAction: TextInputAction.done,
                            onSubmitted: (value) => controller.authorize(),
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                GlobalController()
                                    .loadServerValidators(context)),
                          ),
                          controller.wrongPassword ? Text("كلمة سر غير صحيحة") : SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                child: Text(
                                  "تاكيد",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  controller.authorize();
                                },
                              ),
                            ),
                          ),
                        ])),
            ),
          )),
    );
  }
}
