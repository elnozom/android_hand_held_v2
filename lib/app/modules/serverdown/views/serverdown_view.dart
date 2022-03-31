import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/serverdown_controller.dart';

class ServerdownView extends GetView<ServerdownController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Loader Animation Widget
              Image.asset(
                'assets/images/sad.png',
                width: 250.0,
                height: 100.0,
              ),
              Text("لا يمكننا الاتصال بالخادم",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Theme.of(context).primaryColor)),
              Text(
                  "من فضلك تاكد ان خادمك المحلي يعمل و ان الجهاز متصل بنفس شبكة الخادم",
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: GestureDetector(
                    onTap: () => Get.toNamed("/settings"),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text("تغيير بيانات الاتصال بالخادم",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  )),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => controller.reload(),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: double.infinity,
                  color: Theme.of(context).primaryColor,
                  child: Obx(() {
                    if (controller.loading.value == true) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    } else {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.repeat_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text("اعادة المحاولة",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ],
                      );
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
