import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/product_provider.dart';
import 'package:elnozom_pda/app/helpers/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/state_manager.dart';

import '../../widgets/loading.dart';

class Products {
  final ProductProvider provider = new ProductProvider();
  final DocProvider docProvider = new DocProvider();
  final Account account = new Account();

  // info controllers
  final TextEditingController groupCodeController = TextEditingController();
  final TextEditingController itemCodeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController barCodeController = TextEditingController();
  final TextEditingController minorController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();

  //info focus
  final FocusNode supplierFocus = FocusNode();
  final FocusNode groupCodeFocus = FocusNode();
  final FocusNode itemCodeFocus = FocusNode();
  final FocusNode nameFocus = FocusNode();
  final FocusNode barCodeFocus = FocusNode();
  final FocusNode minorFocus = FocusNode();

  // price controller
  final TextEditingController buyPartPriceController = TextEditingController();
  final TextEditingController buyWholePriceController = TextEditingController();
  final TextEditingController buyPartFinalPriceController =
      TextEditingController();
  final TextEditingController buyWholeFinalPriceController =
      TextEditingController();
  final TextEditingController disc1Controller = TextEditingController();
  final TextEditingController disc2Controller = TextEditingController();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController marginWholeController = TextEditingController();
  final TextEditingController marginPartController = TextEditingController();
  final TextEditingController sellPartPriceController = TextEditingController();
  final TextEditingController sellWholePriceController =
      TextEditingController();

  // price focus
  final FocusNode buyPartPriceFocus = FocusNode();
  final FocusNode buyWholePriceFocus = FocusNode();
  final FocusNode buyWholeFinalPriceFocus = FocusNode();
  final FocusNode buyPartFinalPriceFocus = FocusNode();
  final FocusNode disc1Focus = FocusNode();
  final FocusNode disc2Focus = FocusNode();
  final FocusNode taxFocus = FocusNode();
  final FocusNode marginWholeFocus = FocusNode();
  final FocusNode marginPartFocus = FocusNode();
  final FocusNode sellPartPriceFocus = FocusNode();
  final FocusNode sellWholePriceFocus = FocusNode();
  final FocusNode itemTypeFocus = FocusNode();

  final _infoFormKey = GlobalKey<FormBuilderState>();
  final _priceFormKey = GlobalKey<FormBuilderState>();

  // final TabBarController tablsController = new TabBarController();
  bool active = true;
  bool hasSerial = true;
  bool hasAntherUnit = false;
  bool complex = false;
  RxBool typesLoading = false.obs;
  RxString err = "".obs;
  Rx<String> groupName = "".obs;
  int selectedItemType = 0;

  List<dynamic> types = [];

  bool validateVals() {
    var buyWholeFinal = double.parse(buyWholeFinalPriceController.text);
    var sellWhole = double.parse(sellWholePriceController.text);
    var buyPartFinal = double.parse(buyPartFinalPriceController.text);
    var sellPart = double.parse(sellPartPriceController.text);
    var minor = int.parse(minorController.text);
    if (buyWholeFinal > sellWhole || buyPartFinal > sellPart) {
      err.value = "لا يمكن ان يكون سعر الشراء اقل من سعر البيع";
      return false;
    }
    if (minor == 0) {
      err.value = "لا يمكن ان يكون سعر الشراء اقل من سعر البيع";
      return false;
    }

    return true;
  }


  String? Function(String?) marginValidator(BuildContext context) {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(context, errorText: "نسبة الربح  مطلوب"),
      FormBuilderValidators.numeric(context,
          errorText: " لازم نسبة الربح  تكون رقم"),
      FormBuilderValidators.max(context, 100,
          errorText: " لازم نسبة الربح  تكون نسبة مئوية"),
      FormBuilderValidators.min(context, 0,
          errorText: " لازم نسبة الربح  تكون نسبة مئوية")
    ]);
  }

  String? Function(String?) priceValidator(BuildContext context) {
    return FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "السعر مطلوب"),
                    FormBuilderValidators.numeric(context,
                        errorText: " لازم السعر يكون رقم")
                  ]);
  }
  void calcuateBuyPart() {
    if (minorController.text == "") {
      err.value = "لا يمكن للمحتوي ان يكون خالي";
    }
    if (int.parse(minorController.text) == 0) {
      err.value = "لا يمكن للمحتوي ان يكون صفر";
    }
    buyPartPriceController.text = (double.parse(buyWholePriceController.text) /
            double.parse(minorController.text))
        .toStringAsFixed(2);
  }

  void calcuateBuyFinal() {
    var buyWhole = double.parse(buyWholePriceController.text);
    var minor = double.parse(minorController.text);
    var disc1 =
        disc1Controller.text == '' ? 0.0 : double.parse(disc1Controller.text);
    var disc2 =
        disc2Controller.text == '' ? 0.0 : double.parse(disc2Controller.text);
    var tDisc = disc1 + disc2;
    var tDiscMultiply = (100.0 - tDisc) / 100.0;
    var tax = taxController.text == '' ? 0.0 : double.parse(taxController.text);
    var taxMultiply = (100.0 + tax) / 100.0;
    buyWholeFinalPriceController.text =
        (buyWhole * tDiscMultiply * taxMultiply).toStringAsFixed(2);
    buyPartFinalPriceController.text =
        ((buyWhole * tDiscMultiply * taxMultiply) / minor).toStringAsFixed(2);
  }

  void applyMarginWhole() {
    calcuateBuyFinal();
    var buyWhole = double.parse(buyWholeFinalPriceController.text);
    var margin = marginWholeController.text == ''
        ? 0.0
        : double.parse(marginWholeController.text);
    var marginVal = (buyWhole * margin) / 100.0;
    sellWholePriceController.text = (buyWhole + marginVal).toStringAsFixed(2);
  }

  void applyMarginPart() {
    calcuateBuyFinal();
    var buyPart = double.parse(buyPartFinalPriceController.text);
    var margin = marginPartController.text == ''
        ? 0.0
        : double.parse(marginPartController.text);
    var marginVal = (buyPart * margin) / 100.0;
    sellPartPriceController.text = (buyPart + marginVal).toStringAsFixed(2);
  }

  void calcMarginWhole() {
    var buyWhole = double.parse(buyWholeFinalPriceController.text);
    var sellWhole = double.parse(sellWholePriceController.text);
    var net = sellWhole - buyWhole;
    var percentWhole = (net / buyWhole) * 100;
    marginWholeController.text = percentWhole.toStringAsFixed(2);
  }

  void calcMarginPart() {
    var buyPart = double.parse(buyPartFinalPriceController.text);
    var sellPart = double.parse(sellPartPriceController.text);
    var net = sellPart - buyPart;
    var percentPart = (net / buyPart) * 100;
    marginPartController.text = percentPart.toStringAsFixed(2);
  }

  void groupCodeSubmitted(int data) {
    provider.getMaxCode(data).then((value) {
      groupName.value = value.groupName;
      itemCodeController.text = value.maxCode.toString();
    });
    types = [];
    typesLoading.value = true;
    provider.getTypes(data).then((value) {
      types = value;
      typesLoading.value = false;
    });
  }
  void itemBCodeSubmitted(context) {
    final Map req = {"BCode": barCodeController.text};
    docProvider.getItem(req).then((item) {
     if(item == null) return;
      nameController.text = item.itemName;
      minorController.text = item.minorPerMajor.toString();
      sellPartPriceController.text = item.pOSPP.toString();
      sellWholePriceController.text = item.pOSTP.toString();
      sellWholePriceController.text = item.pOSTP.toString();
      hasAntherUnit = item.itemHasAntherUnit;
      // now we check if we gor response

      

      // _fieldFocusChange(context, itemFocus, wholeQntFocus);
      // change(null, status: RxStatus.success());
      

    });

    return ;
  }
  void generateBarCode() {}
  

  List<Widget> basicInfoFormWidget(BuildContext context) {
    return [
          // Text(controller.config.partInv.toString()),
          Obx(() => Text(
                groupName.value,
                textAlign: TextAlign.right,
              )),
          Row(
            children: [
              SizedBox(
                width: 100,
                child: FormBuilderTextField(
                  name: 'GroupCode',
                  focusNode: groupCodeFocus,
                  controller: groupCodeController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' كود المجموعة',
                  ),
                  // // valueTransformer: (data) => {int.parse(data)},
                  onSubmitted: (data) => {groupCodeSubmitted(int.parse(data))},
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "كود المجموعة مطلوب"),
                    FormBuilderValidators.integer(context,
                        errorText: " لازم الكود يكون رقم")
                  ]),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 40),
              Expanded(
                child: FormBuilderTextField(
                  name: 'ItemCode',
                  focusNode: itemCodeFocus,
                  controller: itemCodeController,
                  // valueTransformer: (data) => {int.parse(data)},
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' كود المنتج',
                  ),
                 
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context,
                        errorText: "كود المنتج مطلوب"),
                    FormBuilderValidators.integer(context,
                        errorText: " لازم الكود يكون رقم")
                  ]),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          FormBuilderTextField(
            name: 'BarCode',
            focusNode: barCodeFocus,
            controller: barCodeController,
            // valueTransformer: (data) => {int.parse(data)},
            textInputAction: TextInputAction.next,
            
            decoration: InputDecoration(
              labelText: ' بار كود المنتج',
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: "بار كود المنتج مطلوب"),
              FormBuilderValidators.integer(context,
                  errorText: " لازم البار كود يكون رقم")
            ]),
            onSubmitted: (data) {
              if (data == "") {
                barCodeController.text =
                    "${groupCodeController.text}${itemCodeController.text}";
              } else {
                itemBCodeSubmitted(context);
              }
              barCodeFocus.unfocus();
              FocusScope.of(context).requestFocus(nameFocus);
            },
            // // valueTransformer: (text) => num.tryParse(text),
            keyboardType: TextInputType.number,
          ),
          FormBuilderTextField(
            name: 'Name',
            focusNode: nameFocus,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: " اسم المنتج مطلوب"),
            ]),
            controller: nameController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: ' اسم المنتج',
            ),
            onSubmitted: (data) {
              nameFocus.unfocus();
              FocusScope.of(context).requestFocus(minorFocus);
            },
            // valueTransformer: (text) => num.tryParse(text),
            keyboardType: TextInputType.text,
          ),

          FormBuilderTextField(
            name: 'MinorPerMajor',
            focusNode: minorFocus,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(context,
                  errorText: " اسم المنتج مطلوب"),
              FormBuilderValidators.integer(context,
                  errorText: " لازم المحتوي يكون رقم"),
              FormBuilderValidators.min(context, 1,
                  errorText: " لازم المحتوي يكوي 1 علي الاقل")
            ]),
            controller: minorController,
            textInputAction: TextInputAction.next,
            valueTransformer: (data) => {int.parse(data)},
            decoration: InputDecoration(
              labelText: ' محتوي المنتج',
            ),
            // valueTransformer: (text) => num.tryParse(text),
            keyboardType: TextInputType.number,
          ),
          account.getAccountSearch(context, 2, 'المورد الرئيسي'),
          Obx(
            () => typesLoading.value
                ? LoadingWidget()
                : FormBuilderDropdown<int>(
                    name: "ItemTypeID",
                    allowClear: true,
                    onChanged: (value) {
                      selectedItemType = value!;
                    },
                    items: types.map((type) {
                      return DropdownMenuItem<int>(
                          value: type['ItemTypeID'],
                          child: Text(type['ItemTypeName']));
                    }).toList(),
                    focusNode: itemTypeFocus,
                    hint: Text("نوع المنتج")),
          ),
          Row(
            children: [
              SizedBox(
                  width: 170,
                  child: FormBuilderCheckbox(
                    initialValue: this.active,
                    name: "ActiveItem",
                    title: Text("يتم استخدام الصنف"),
                    onChanged: (value) => this.active = value!,
                  )),
              SizedBox(
                  width: 170,
                  child: FormBuilderCheckbox(
                    initialValue: this.hasSerial,
                    name: "ItemHaveSerial",
                    title: Text("سيريال"),
                    onChanged: (value) => this.hasSerial = value!,
                  )),
            ],
          ),
          Row(
            children: [
              SizedBox(
                  width: 170,
                  child: FormBuilderCheckbox(
                    initialValue: this.hasAntherUnit,
                    name: "ItemHaveAntherUint",
                    title: Text("وحدة اخرى"),
                    onChanged: (value) => this.hasAntherUnit = value!,
                  )),
              SizedBox(
                  width: 170,
                  child: FormBuilderCheckbox(
                    initialValue: this.complex,
                    name: "MasterItem",
                    title: Text("مركب"),
                    onChanged: (value) => this.complex = value!,
                  )),
            ],
          ),
          
        ];
  }

  List<Widget> priceingFormWidget(BuildContext context) {
    return [
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'buy_whole_price',
                  focusNode: buyWholePriceFocus,
                  controller: buyWholePriceController,
                  textInputAction: TextInputAction.next,
                  validator:priceValidator(context) ,
                  decoration: InputDecoration(
                    labelText: ' سعر الشراء الكلي',
                  ),
                  onChanged: (data) {
                    calcuateBuyPart();
                  },
                  onSubmitted: (data) {
                    buyWholePriceFocus.unfocus();
                    FocusScope.of(context).requestFocus(disc1Focus);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 40),
              Expanded(
                child: FormBuilderTextField(
                  name: 'buy_part_price',
                  focusNode: buyPartPriceFocus,
                  controller: buyPartPriceController,
                  readOnly: true,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' سعر الشراء الجزئي',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 40),
            ],
          ),

          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'disc_1',
                  focusNode: disc1Focus,
                  controller: disc1Controller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '1 خصم',
                  ),
                  onChanged: (data) {
                    calcuateBuyFinal();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  name: 'disc_2',
                  focusNode: disc2Focus,
                  controller: disc2Controller,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'خصم 2',
                  ),
                  onSubmitted: (data) {
                    calcuateBuyFinal();
                    disc2Focus.unfocus();
                    FocusScope.of(context).requestFocus(taxFocus);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'LastBuyPrice',
                  focusNode: buyWholeFinalPriceFocus,
                  readOnly: true,
                  controller: buyWholeFinalPriceController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' سعر شراء كلي نهائي',
                  ),
                  onSubmitted: (data) {
                    print(data);
                    // buyPartPriceController.text = (double.parse(data) / double.parse(minorController.text)).toString();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 40),
              Expanded(
                child: FormBuilderTextField(
                  name: 'buy_part_price_final',
                  focusNode: buyPartFinalPriceFocus,
                  readOnly: true,
                  controller: buyPartFinalPriceController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: '  سعر شراء جزئي نهائي',
                  ),
                  onSubmitted: (data) {
                    print(data);
                    // buyPartPriceController.text = (double.parse(data) / double.parse(minorController.text)).toString();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          FormBuilderTextField(
            name: 'tax',
            focusNode: taxFocus,
            controller: taxController,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: ' ضريبة القيمة المضافة',
            ),
            onSubmitted: (data) => {calcuateBuyFinal()},
            keyboardType: TextInputType.number,
          ),

          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'Ratio1',
                  focusNode: marginWholeFocus,
                  controller: marginWholeController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' نسبة الربح الكلي',
                  ),
                  validator: marginValidator(context),
                  onSubmitted: (data) {
                    applyMarginWhole();
                  },
                  // valueTransformer: (text) => num.tryParse(text),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  name: 'Ratio2',
                  focusNode: marginPartFocus,
                  controller: marginPartController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' نسبة الربح الجزئي',
                  ),
                  validator: marginValidator(context),
                  onSubmitted: (data) {
                    applyMarginPart();
                  },
                  // valueTransformer: (text) => num.tryParse(text),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'POSTP',
                  focusNode: sellWholePriceFocus,
                  controller: sellWholePriceController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'سعر البيع الكلي',
                  ),
                  validator : priceValidator(context),
                  onSubmitted: (data) {
                    calcMarginWhole();
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  name: 'POSPP',
                  focusNode: sellPartPriceFocus,
                  controller: sellPartPriceController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: ' سعر البيع الجزئي',
                  ),
                  validator : priceValidator(context),
                  onSubmitted: (data) {
                    calcMarginPart();
                    FocusScope.of(context).unfocus();
                    FocusScope.of(context).requestFocus(sellWholePriceFocus);
                  },
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          
        ];
  }



  
}
