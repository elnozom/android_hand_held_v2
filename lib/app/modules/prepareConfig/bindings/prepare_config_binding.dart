import 'package:get/get.dart';

import '../controllers/prepare_config_controller.dart';

class PrepareConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrepareConfigController>(
      () => PrepareConfigController(),
    );
  }
}
