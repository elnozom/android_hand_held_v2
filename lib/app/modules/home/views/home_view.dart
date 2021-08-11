import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../controllers/home_controller.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';
final people = <Person>[
  Person('Alice', '123 Main'),
  Person('Alice', '123 Main'),
  Person('Alice', '123 Main'),
  Person('Alice', '123 Main'),
  Person('Bob', '456 Main')
];
final letters = 'abcdefghijklmnopqrstuvwxyz'.split('');

class Person {
  Person(this.name, this.address);
  final String name, address;
  @override
  String toString() => name;
}

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('HomeView'),
          centerTitle: true,
        ),
        body: controller.obx((state) => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    SimpleAutocompleteFormField<Item>(
                      maxSuggestions: 5,
                      suggestionsHeight: 300,
                      
                      decoration: InputDecoration(
                          labelText: 'Person'),
                      itemBuilder: (context, item) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item!.itemName,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ]),
                      ),
                      onSearch: (search) async => controller.items
                          .where((item) => item.itemName
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                          .toList(),
                          itemToString: (item) {
                            return item == null ? "" : item.itemName;
                          },
                      itemFromString: (string) {
                        final matches = controller.items.where((item) =>
                            item.itemName.toLowerCase() ==
                            string.toLowerCase());
                        return matches.isEmpty ? null : matches.first;
                      },
                      onSaved: controller.onChanged,
                      validator: (item) =>
                          item == null ? 'Invalid item.' : null,
                    ),
                    FormBuilder(
                      key: controller.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: Column(
                        children: <Widget>[
                          FormBuilderTextField(
                            name: 'bcode_item',
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: 'ادخل كود المنتج',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'bcode_acc',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل كود الحساب',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'bcode_هىر',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل كود الفاتورة',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'qnt_whole',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل الكمية الكلية',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'qnt',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل الكمية الجزئية',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'year',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل السنة',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'month',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل الشهر',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderTextField(
                            name: 'device',
                            autofocus: true,
                            textInputAction: TextInputAction.next,

                            decoration: InputDecoration(
                              labelText: 'ادخل رقم الجهاز',
                            ),
                            onSubmitted: controller.onChanged,
                            // valueTransformer: (text) => num.tryParse(text),
                            validator: FormBuilderValidators.compose(
                                controller.loadValidators(context)),
                            keyboardType: TextInputType.number,
                          ),
                          FormBuilderDropdown(
                            name: 'store',
                            decoration: InputDecoration(
                              labelText: 'store',
                            ),
                            // initialValue: 'Male',
                            allowClear: true,
                            hint: Text('Select store'),
                            validator: FormBuilderValidators.compose(
                                [FormBuilderValidators.required(context)]),
                            items: controller.stores.map((Store store) {
                              return DropdownMenuItem(
                                value: store.storeCode,
                                child: Text(store.storeName),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            color: Theme.of(context).accentColor,
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              controller.formKey.currentState!.save();
                              if (controller.formKey.currentState!.validate()) {
                                print(controller.formKey.currentState!.value);
                              } else {
                                print("validation failed");
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )));
  }
}
