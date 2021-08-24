import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/acc_provider.dart';
import 'package:elnozom_pda/app/data/doc_provider.dart';
import 'package:elnozom_pda/app/data/global_provider.dart';
import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/config_model.dart';
import 'package:elnozom_pda/app/data/models/emp_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_config_model.dart';
import 'package:elnozom_pda/app/data/models/prepare_item_model.dart';
import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class PrepareConfigController extends GetxController {
  final invBCode = TextEditingController();
  final empBCode = TextEditingController();
  final FocusNode invBCodeFocus = FocusNode();
  final FocusNode empBCodeFocus = FocusNode();
  Config config = Get.arguments;
  final formKey = GlobalKey<FormBuilderState>();
  // this will be true if we called the server with barcode entered by the use and got nothing
  Rx<bool> empErr = false.obs;
  Rx<bool> invErr = false.obs;

  Rx<Emp> emp = Emp(empCode: -1, empName: "", empPassword: "").obs;
  Emp emptyEmp = Emp(empCode: -1, empName: "", empPassword: "");
  List<PrepareItem> invoice = [];
  //create the new document after loading the data from the inputs
  void create(context) async {
    formKey.currentState!.save();
    if (formKey.currentState!.validate()) {
      //check if invoice is not loaded
      if (invoice.isEmpty) {
        getInv(context);
      }
      if (emp.value.empCode != -1 && invoice != null) {
        PrepareConfig arguments = PrepareConfig(
            empCode: int.parse(empBCode.text),
            hSerial: int.parse(invoice.first.bonSer),
            invoice: invoice);
        Get.toNamed('/prepare', arguments: arguments);
      }
    } else {
      print("validation failed");
    }

    // change(null, status: RxStatus.success());
  }

  void clearEmp(context) {
    empBCode.text = "";
    emp.value = emptyEmp;
    invBCodeFocus.unfocus();
    Future.delayed(const Duration(milliseconds: 500), () {
      FocusScope.of(context).requestFocus(empBCodeFocus);
    });
  }

  // this function will be executed when the user hit enter on the barcode input
  void empBCodeSubmitted(context) {
    // first we validate the
    // if request is valid then declare the request var
    // send the request to the server
    // check if not found
    // set the emp varibale to one from the server
    var req = {"EmpCode": int.parse(empBCode.text)};
    AccProvider().getEmp(req).then((resp) {
      if (resp != null) {
        emp.value = resp;
        empErr.value = false;
        print("Asdasd");
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(invBCodeFocus);
        });
      } else {
        empErr.value = true;
        clearEmp(context);
      }
      // change(null, status: RxStatus.success());
    }, onError: (err) {
      clearEmp(context);
      // change(null, status: RxStatus.error(err));
    });
  }

  void getInv(context) {
    var req = {
      "BCode": invBCode.text,
    };
    DocProvider().getInv(req).then((resp) {
      if (resp.isNotEmpty) {
        invErr.value = false;
        invoice = resp;
        create(context);
      } else {
        invErr.value = true;
        invBCode.text = '';
        Future.delayed(const Duration(milliseconds: 500), () {
          FocusScope.of(context).requestFocus(invBCodeFocus);
        });

        // change(null, status: RxStatus.success());
      }
    }, onError: (err) {
      invErr.value = true;
      // invBCode.text = '';
      print(err);
      // change(null, status: RxStatus.error(err.toString()));
    });
  }

  // this function will be executed when the user hit enter on the barcode input
  // we want to chek if we are creatint prepare document then we make sure to load employee
  void invBCodeSubmitted(context) {
    // first we validate the
    // if request is valid then declare the request var
    // call the getInv func
    if (formKey.currentState!.validate()) {
      getInv(context);
    }
  }

  void onInit() async {
    // Simulating obtaining the user name from some local storage
    super.onInit();
    empBCode.clear();
    invBCode.clear();
  }

  void onClose() {
    empBCode.clear();
    invBCode.clear();
  }
}
