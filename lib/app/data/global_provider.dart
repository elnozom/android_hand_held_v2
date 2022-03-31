import 'package:elnozom_pda/app/data/models/store_model.dart';
import 'package:get/get.dart';
import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
// import 'package:imei_plugin/imei_plugin.dart';

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

  Future<int> checkDevice() async {
    config = await GlobalController().getConfigCache();
    // String imei = await ImeiPlugin.getImei();
    String imei = "123";
    //  print(imei);
    Map data = {"DeviceId" : GlobalController().encrypt(imei)};
    final response = await post('${config.server}devices/check' , data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
  Future<int> insertDevice() async {
    config = await GlobalController().getConfigCache();
    // String imei = await ImeiPlugin.getImei();
    String imei = "123";
      Map data = {"DeviceId" : GlobalController().encrypt(imei)};
    final response = await post('${config.server}devices/insert' , data);
    if (response.status.hasError) {
       return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }


  Future<List<dynamic>> getEmp(int code) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}employee?EmpCode=${code}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      return response.body;
    }
  }
}
