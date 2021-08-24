import 'package:get/get.dart';

import '../controllers/prepare_controller.dart';

class PrepareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrepareController>(
      () => PrepareController(),
    );
  }
}
