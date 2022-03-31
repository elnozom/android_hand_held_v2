import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:simple_autocomplete_formfield/simple_autocomplete_formfield.dart';

class Account {
  final ProductProvider provider = new ProductProvider();
  String? lastAccountSearchChar;
  int? accountCode;
  int? accountSerial;
  String? accountName;
  List<Acc> accountSuggestions = [];
  Future<List<Acc?>> searchAccs(String search ,int accType) async {
    // check if use just added the first char to search
    // check if this char is not the last char we searched for
    // so now we know that the input has only one char and this char is not our last one
    // so now we need to call the server to load all account have this letter
    if (search.length == 1 && search != lastAccountSearchChar) {
      lastAccountSearchChar = search;
      accountSuggestions = await GlobalController()
          .loadAccountsAutcomplete(search, accType);

      // check if we already loaded the accounts from the server so we search
      // here we make a clone of our suggestions to not corrubt the original one
      // so if the user deleted the letter and start typing again everthing will work well
    } else {
      List<Acc> filteredAccountSuggestions = accountSuggestions
          .where((item) =>
              item.accountName.toLowerCase().contains(search.toLowerCase()) ||
              item.accountCode
                  .toString()
                  .toLowerCase()
                  .contains(search.toLowerCase()))
          .toList();

      return filteredAccountSuggestions;
    }
    return accountSuggestions;
  }
  void accountAutocompleteSaved(data) {
    accountCode = data.accountCode;
    accountSerial = data.serial;
    accountName = data.accountName;
  }
  SimpleAutocompleteFormField<Acc> getAccountSearch(context, accType , label) {
    return SimpleAutocompleteFormField<Acc>(
      maxSuggestions: 20,
      suggestionsHeight: 100,
      decoration: InputDecoration(labelText: label),
      itemBuilder: (context, item) => Padding(
        padding: EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${item!.accountName}',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text('كود رقم : ${item.accountCode.toString()}',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ),
      onSearch: (search) async => searchAccs(search , accType),
      itemToString: (item) {
        return item == null ? "" : item.accountName;
      },
      itemFromString: (string) {
        final matches = GlobalController().accountSuggestions.where(
            (item) => item.accountName.toLowerCase() == string.toLowerCase());
        return matches.isEmpty ? null : matches.first;
      },
      onChanged: accountAutocompleteSaved,
    );
  }
}
