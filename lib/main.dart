import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      locale: Locale('ar', 'AE'),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
localizationsDelegates: [
        FormBuilderLocalizations.delegate,
      ],
    ),
  );
}
