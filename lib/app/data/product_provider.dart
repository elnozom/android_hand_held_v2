import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/product_group.dart';
import 'package:get/get.dart';

class ProductProvider extends GetConnect {
  ConfigCache config = ConfigCache();
  Future<int> createInfo(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}products/info', data);
    return response.body;
  }

  Future<ProductGroup> getMaxCode(int group) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}products/maxCode/${group}');
    return ProductGroup.fromJson(response.body);
  }

  Future<List<dynamic>> getTypes(int group) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}products/types/${group}');
    return response.body;
  }

  
}
