class Store {
  int storeCode = 0;
  String storeName = '';

  Store({required this.storeCode, required this.storeName});

  Store.fromJson(Map<String, dynamic> json) {
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['StoreCode'] = storeCode;
    data['StoreName'] = storeName;
    return data;
  }
}
