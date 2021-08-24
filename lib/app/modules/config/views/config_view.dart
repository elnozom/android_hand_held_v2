import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:get/get.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

import '../controllers/config_controller.dart';

class ConfigView extends GetView<ConfigController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await Get.offAllNamed('/home');
          return true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('مستند جديد'),
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
                child: controller.obx(
                  (state) => SingleChildScrollView(
                    child: Column(
                      children: [
                        FormBuilder(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: <Widget>[
                              if (controller.showAccBarcode)
                                FormBuilderTextField(
                                  name: 'bcode_acc',
                                  autofocus: true,
                                  controller: controller.accBCode,
                                  decoration: InputDecoration(
                                    labelText: 'ادخل كود الحساب',
                                  ),
                                  onSubmitted: controller.accBCodeSubmitted,
                                  // valueTransformer: (text) => num.tryParse(text),
                                  validator: FormBuilderValidators.compose(
                                      GlobalController()
                                          .loadConfigBarCodeValidators(
                                              context)),
                                  keyboardType: TextInputType.number,
                                ),
                              if (controller.noAccFound)
                                Text("عفوا هذا الحساب غير موجود"),
                              Text(controller.accountName),
                              if (controller.showAccSearch)
                                SimpleAutocompleteFormField<Acc>(
                                  maxSuggestions: 20,
                                  suggestionsHeight: 100,
                                  decoration: InputDecoration(
                                      labelText: 'ابحث عن الحساب'),
                                  itemBuilder: (context, item) => Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${item!.accountName}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                              'كود رقم : ${item.accountCode.toString()}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                        ]),
                                  ),
                                  onSearch: (search) async =>
                                      controller.searchAccs(search),
                                  itemToString: (item) {
                                    return item == null ? "" : item.accountName;
                                  },
                                  itemFromString: (string) {
                                    final matches = GlobalController()
                                        .accountSuggestions
                                        .where((item) =>
                                            item.accountName.toLowerCase() ==
                                            string.toLowerCase());
                                    return matches.isEmpty
                                        ? null
                                        : matches.first;
                                  },
                                  onChanged:
                                      controller.accountAutocompleteSaved,
                                ),
                              // hide this option prementetly if we are on the transaction
                              if (controller.config.trSerial != 27)
                                TextButton(
                                    child: Text(controller.showSearchText),
                                    onPressed: controller.toggleShowSearchAcc),

                              if (controller.showToStore)
                                FormBuilderDropdown<Store>(
                                  name: 'store',
                                  decoration: InputDecoration(
                                    labelText: 'اختر المخزن',
                                  ),
                                  // initialValue: 'Male',
                                  allowClear: true,
                                  hint: Text('اختر المخزن'),
                                  onChanged: controller.toStoreChanged,

                                  items: controller.storesDropdownItems,
                                ),
                              
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
                                controller.create();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))));
  }
}
