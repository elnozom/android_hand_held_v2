import 'package:get/get.dart';

import '../controllers/serverdown_controller.dart';

class ServerdownBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerdownController>(
      () => ServerdownController(),
    );
  }
}
