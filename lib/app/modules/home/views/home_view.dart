import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.init();
    return Obx( () { return controller.loading.value == true
        ?  Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Loader Animation Widget

                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              toolbarHeight: 80.0,
              title: Container(
                alignment: Alignment.topLeft, // This is needed
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain,
                  width: 250,
                ),
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home-bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: GridView.count(
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(HomeController().tabs.length, (index) {
                  return GestureDetector(
                    onTap: () => HomeController().goTo(index),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.5),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                HomeController().tabs[index].icon!,
                                color: Colors.white,
                                size: 40.0,
                              ),
                              Center(
                                child: Text(
                                  HomeController().tabs[index].text!,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  );
                }),
              ),
            ),
          );});
  }
}
