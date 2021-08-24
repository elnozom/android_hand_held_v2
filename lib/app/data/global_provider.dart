import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:get/get.dart';
import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';

class GlobalProvider extends GetConnect {
  @override
  ConfigCache config = ConfigCache();
  Future<List<Store>> getStores() async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}cashtry/stores');
    List<Store> stores = [];
    if (response.status.hasError) {
      return stores;
    } else {
      
      if (response.body != null)
        response.body.forEach((item) {
          Store store = Store.fromJson(item);
          stores.add(store);
        });
      return stores;
    }
  }
}
