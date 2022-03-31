
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';



void main()  {
  // await checkDeviceAuthorizatioon();

  runApp(
    GetMaterialApp(
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: Colors.lightBlue[800],
        // Define the default font family.
        fontFamily: 'Frutiger',
      ),
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
