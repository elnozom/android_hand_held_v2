import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/doc_item_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class EditController extends GetxController{
  //search 
  final itemController = TextEditingController();
  final FocusNode itemFocus = FocusNode();
  // inputs controllers
  final codeController = TextEditingController();
  final wholeQntController = TextEditingController();
  final qntController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  // inputs focus nodes
  final FocusNode itemCodeFocus = FocusNode();
  final FocusNode qntFocus = FocusNode();
  final FocusNode wholeQntFocus = FocusNode();
  final FocusNode monthFocus = FocusNode();
  final FocusNode yearFocus = FocusNode();

  Rx<bool> itemNotFound = false.obs;
  Rx<bool> qntErr = false.obs;

  // flag to use on input textInputAction to set to done or next
  Rx<bool> qntWholeIsLastInput = true.obs;
  //inputs checks
  Rx<bool> qntHidden = false.obs;
  Rx<bool> searchHidden = true.obs;


  Item emptyItem =  Item(
    serial : 0,
    itemName : "0",
    minorPerMajor : 0,
    pOSPP : 0,
    pOSTP : 0,
    byWeight : false,
    withExp : false,
    itemHasAntherUnit : false,
    avrWait : 0,
    expirey : "0",
  );
  //this is the item from the serve
  Rx<Item> itemData = Item(
    serial : 0,
    itemName : "0",
    minorPerMajor : 0,
    pOSPP : 0,
    pOSTP : 0,
    byWeight : false,
    withExp : false,
    itemHasAntherUnit : false,
    avrWait : 0,
    expirey : "0",
  ).obs;

  // falg to identify that the item is with the expiry data and we can catch ite from the server
  Rx<bool> expExisted = false.obs;
  // falg to identify that the item is with the expiry data or not
  Rx<bool> withExp = false.obs;

  final formKey = GlobalKey<FormBuilderState>();
  Config config = Get.arguments;
  List<String> columns = [
    "المنتج",
    "اجرائات",
  ];

  RxList<dynamic> items = [].obs;
  get itemsList => items;

    // search logic
    String? lastItemSearchChar;
    List<Item> itemSuggestions = [];
    Future<List<Item?>> searchItems(String search) async {
    // check if use just added the first char to search
    // check if this char is not the last char we searched for
    // so now we know that the input has only one char and this char is not our last one
    // so now we need to call the server to load all account have this letter
    if (search.length == 1 && search != lastItemSearchChar) {
      lastItemSearchChar = search;
      itemSuggestions =
          await GlobalController().loadProductsAutcomplete(search);

      // check if we already loaded the accounts from the server so we search
      // here we make a clone of our suggestions to not corrubt the original one
      // so if the user deleted the letter and start typing again everthing will work well
    } else {
      List<Item> filteredItemSuggestions = itemSuggestions.where((item) {
        return item.itemName.toLowerCase().contains(search.toLowerCase());
      }).toList();

      // print(filteredItemSuggestions);
      return filteredItemSuggestions;
    }
    return itemSuggestions;
  }
  
    void itemAutocompleteSaved(context, Item item) {
      codeController.text=item.serial.toString();
      searchHidden.value = true;
      itemLoaded(context , item);
      _fieldFocusChange(context, itemFocus, wholeQntFocus);
  }
  /// Only relevant for SimplePage at bottom
  void closeDoc() async {
    final Map req = {
      "trans": config.trSerial,
      "DocNo": config.docNo
    };
    // print(req);
    var resp = await DocProvider().closeDoc(req);

    Get.toNamed('/home');
  }


  void itemLoaded(context , resp){
    if (resp == null) {
        _fieldFocusChange(context, itemFocus, itemFocus);
        codeController.text = "";
        itemNotFound.value = true;
        itemData.value = emptyItem;
        return ;
      } 

      //if we come heree that means we have got the item from the server successfully
      itemData.value = resp;
      
      itemNotFound.value = false;
      // _fieldFocusChange(context, itemFocus, wholeQntFocus);
      

      // aet the with exp fkag to the value from the server
      withExp.value = resp.withExp;

      // first we set the expexisted to its default value
      // then we check if we can got this from the server
      // then we set the calue of data inputs from our expiry from the server if its there
      expExisted.value = false;
      if (resp.withExp) {
        //if expiry is = 0 that means we cant access it from the server
        if (resp.expirey != '0') {
          monthController.text = resp.expirey.substring(0, 2);
          yearController.text = resp.expirey.substring(2);
          expExisted.value = true;
        } else {
          // if we reached here that means the item is with expiry and it didnt come from the server
          // so we need to show the month and year inputs
          // so the whole qnt field is not our last
          qntWholeIsLastInput.value = false;
        }
      }
      //check if the minor per mahor is 1
      // that means we dont have any part qnt
      // so we hide its input
      if (resp.minorPerMajor == 1) {
        qntController.text = '0';
        qntHidden.value = true;
      } else {
        qntHidden.value = false;
      }
  }
  void itemBCodeSubmitted(context, data) {
    final Map req = {"BCode": data.toString()};
    DocProvider().getItem(req).then((resp) {
      // now we check if we gor response
      itemLoaded(context , resp);
      

      // _fieldFocusChange(context, itemFocus, wholeQntFocus);
      // change(null, status: RxStatus.success());
      

    });

    return ;
  }

  void submit(context) async {
    formKey.currentState!.save();
    if (!formKey.currentState!.validate()) {
      return ;
    }


    //check if item data is not set
    if (itemData.value == emptyItem) {
      if(codeController.text != ""){
        itemBCodeSubmitted(context, codeController.text);
      }
      itemNotFound.value = true;
      return ;
    } else {
      // declar the qnt
      // set the value of qntcontroller to = if its not set
      // then check if the item is byweight to set qnt to the whole qnt value
      // if false then we make our calculation as (whole qnt * minor + part qnt)
      // ant then we have the qnt value which will bend send to the server
      int qnt;
      if (itemData.value.byWeight) {
        qnt = int.parse(wholeQntController.text);
      } else {
        qntController.text = qntController.text == "" ? '0' : qntController.text;
        int minor = itemData.value.minorPerMajor;
        qnt = int.parse(wholeQntController.text) * minor +
        int.parse(qntController.text);

      }

      // CHECK IF qnt is 0 to show error
      if (qnt == 0) {
        qntErr.value = true;
        return ;
      }
      // if we reached  here that means we are loaded the qnt succesflly
      qntErr.value = false;

      // now we set the expDate string as we like to send it to the server
      var expD = monthController.text != ""
          ? '${monthController.text}/1/${yearController.text}'
          : null;
      final Map req = {
        "DNo": config.docNo,
        "TrS": config.trSerial,
        "AccS": config.accSerial,
        "ItmS": itemData.value.serial,
        "Qnt": qnt,
        "StCode2": config.toStore != null ? config.toStore : 0,
        "InvNo": 0,
        "ItmBarCode": codeController.text,
        "ExpDate": expD,
        "SessionNo" : config.sessionNo
      };
      
      var resp = await DocProvider().insertItem(req);
      expD = null;
      reset(context);
    

      return ;

    }
   

    
  }

  void reset(context){
      itemData.value = emptyItem;
      itemController.clear();
      qntController.clear();
      wholeQntController.clear();
      codeController.clear();
      monthController.clear();
      yearController.clear();
      searchHidden.value = true;
      withExp.value = false;
      fetchItems();

      _fieldFocusChange(context, wholeQntFocus, itemCodeFocus);
      
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  DataRow generateRows(DocItem item) {
    List<DataCell> wid = [];

    String wholQnt;
    String qnt;
    // check if item is by weight
    // set the whole qnt to the the qnt
    // and set the part qnt to 0
    // becaus if item is by weight the all the quantity will be whol
    if (item.byWeight == true) {
      wholQnt = item.qnt.toString();
      qnt = '0';

      //check if item is not by weight
      // set the wgoleqnt to the qnt from the server devided by minorpermajor and floor it to the lowest integer example[1.9 = 1  , 0.8 = 0]
      // and then set the part qny to the remainded of the divide operation example[26/5 then qnt will be 1]
    } else {
      wholQnt = (item.qnt / item.minorPerMajor).floor().toString();
      qnt = (item.qnt.remainder(item.minorPerMajor)).toString();
    }
    wid.add(DataCell(Text(
        '${item.itemName} \n  الكمية الكلية : ${wholQnt} \n الكمية الجزئية : ${qnt} ')));
    wid.add(DataCell(ElevatedButton(
        onPressed: () async {
          var req = {"Serial": item.serial};
          await DocProvider().removeDocItem(req);
          fetchItems();
        },
        child: Text('حذف'))));

    return DataRow(
      cells: wid,
    );
  }

  void fetchItems() async {
    final Map req = {"TrSerial": config.trSerial, "DocNo": config.docNo};
    var resp = await DocProvider().getItems(req);
    items.value = resp;
    // change(null, status: RxStatus.success());
  }

  void onChanged(data) {
    print(data);
  }
  void wholeQntChanged(context, data) {
    if (!qntHidden.value){
      _fieldFocusChange(context, wholeQntFocus , qntFocus);
    }
    if (withExp.value && qntHidden.value) {
      _fieldFocusChange(context, wholeQntFocus, monthFocus);
    }

    if (!withExp.value && qntHidden.value) {
      submit(context);
    }
  }

  void qntChanged(context, data) async {
    if (withExp.value && !expExisted.value) {
        _fieldFocusChange(context, qntFocus, monthFocus);
    } else {
      submit(context);
    }
  }

  void monthChanged(context, data) {
    // if(data.length > 2){
    //   dateErr = true;
    // }
    // int intD = int.parse(data);
    // if(intD > 12 || intD <=0){
    //   dateErr = true;
    // }
    _fieldFocusChange(context, monthFocus, yearFocus);
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }
}
