import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import '../controllers/prepare_config_controller.dart';

class PrepareConfigView extends GetView<PrepareConfigController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home');
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('تحضير مستند'),
              centerTitle: false,
              actions: [
                IconButton(
                  onPressed: () => {},
                  icon: Icon(Icons.add),
                )
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                    child: Column(
                      children: [
                        FormBuilder(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: <Widget>[
                              Obx(() {
                                return FormBuilderTextField(
                                  name: 'bcode_emp',
                                  enabled: controller.emp.value.empCode == -1,
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  autofocus: true,
                                  textInputAction: TextInputAction.next,
                                  focusNode: controller.empBCodeFocus,
                                  controller: controller.empBCode,
                                  decoration: InputDecoration(
                                    labelText: 'ادخل كود الموظف',
                                  ),
                                  onSubmitted: (data) => {controller.empBCodeSubmitted(context)},
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose(
                                      GlobalController()
                                          .loadConfigEmpBarCodeValidators(
                                              context)),
                                  keyboardType: TextInputType.number,
                                );
                              }),
                                
                                Obx(() {
                                  return controller.empErr.value == true ?  Text('لا  يوجد موظف بهذا الكود') : SizedBox(height:0);
                                }),
                                Obx(() {
                                  return controller.emp.value.empCode != -1 ?  Column(
                                    children: [
                                      Text('${controller.emp.value.empName}'),
                                      TextButton(child: Text('تعديل الموظف') , onPressed: () => {controller.clearEmp(context)}),
                                    ],
                                  ) : SizedBox(height:0);
                                }),
                                Obx((){
                                  return FormBuilderTextField(
                                  name: 'bcode_inv',
                                  enabled: controller.emp.value.empCode != -1,
                                  focusNode: controller.invBCodeFocus,
                                  controller: controller.invBCode,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: 'ادخل كود الفاتورة',
                                  ),
                                  onSubmitted: (data) => { controller.invBCodeSubmitted(context)},
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose(
                                      GlobalController()
                                          .loadConfigBarCodeValidators(
                                              context)),
                                  keyboardType: TextInputType.number,
                                );
                                }),
                                
                                Obx(() {
                                  return controller.invErr.value == true ?  Text('لا توجد فاتور بهذا الكود') : SizedBox(height:0);
                                }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                "استمرار",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                controller.create(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )));
  }
}
