import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

SimpleAutocompleteFormField<Item> getProductsSearch(context, controller) {
  return SimpleAutocompleteFormField<Item>(
    maxSuggestions: 20,
    controller: controller.itemController,
    focusNode: controller.itemFocus,
    suggestionsHeight: 100,
    decoration: InputDecoration(labelText: 'ابحث عن المنتج'),
    itemBuilder: (context, item) => Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${item!.itemName}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text('المحتوي : ${item.minorPerMajor}',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ]),
    ),
    onSearch: (search) async => controller.searchItems(search),
    itemToString: (item) {
      return item == null ? "" : item.itemName;
    },
    itemFromString: (string) {
      final matches = GlobalController()
          .itemSuggestions
          .where((item) => item.itemName.toLowerCase() == string.toLowerCase());
      return matches.isEmpty ? null : matches.first;
    },
    autofocus: true,
    onChanged: (item) => {controller.itemAutocompleteSaved(context, item)},
  );
}
