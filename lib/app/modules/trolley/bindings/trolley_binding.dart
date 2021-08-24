import 'package:get/get.dart';

import '../controllers/trolley_controller.dart';

class TrolleyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrolleyController>(
      () => TrolleyController(),
    );
  }
}
