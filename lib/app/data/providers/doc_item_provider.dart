import 'package:get/get.dart';

import '../models/doc_item_model.dart';

class DocItemProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return DocItem.fromJson(map);
      if (map is List)
        return map.map((item) => DocItem.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<DocItem?> getDocItem(int id) async {
    final response = await get('docitem/$id');
    return response.body;
  }

  Future<Response<DocItem>> postDocItem(DocItem docitem) async =>
      await post('docitem', docitem);
  Future<Response> deleteDocItem(int id) async => await delete('docitem/$id');
}
