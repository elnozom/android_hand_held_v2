import 'package:get/get.dart';

import '../models/store_model.dart';

class StoreProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Store.fromJson(map);
      if (map is List) return map.map((item) => Store.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Store?> getStore(int id) async {
    final response = await get('store/$id');
    return response.body;
  }

  Future<Response<Store>> postStore(Store store) async =>
      await post('store', store);
  Future<Response> deleteStore(int id) async => await delete('store/$id');
}
