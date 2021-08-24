import 'package:elnozom_pda/app/controllers/global_controller.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/data/models/item_model.dart';
import 'package:elnozom_pda/app/data/models/order_item_model.dart';
import 'package:get/get.dart';

class OrdersProvider extends GetConnect {
  ConfigCache config = ConfigCache();

  Future<int> insertOrder(Map data) async {
    config = await GlobalController().getConfigCache();
    // data['DevNo'] = config.device;
    data['StoreCode'] = config.store;
    final response = await post('${config.server}orders', data);
    return response.body;
  }
  Future<String> insertOrderItem(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}orders/item', data);
    return response.body;
  }

  Future<List<OrderItem>> getOrderItems(int serial) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}orders/items?Serial=${serial}');
     if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<OrderItem> items = [];
      if (response.body != null)
        response.body.forEach((item) {
          OrderItem orderItem = OrderItem.fromJson(item);
          items.add(orderItem);
        });
      return items;
    }
  }

  
  // insertOrderItem


  
}
