class Store {
  int storeCode = 0;
  String storeName = '';

  Store({required this.storeCode, required this.storeName});

  Store.fromJson(Map<String, dynamic> json) {
    storeCode = json['store_code'];
    storeName = json['store_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['store_code'] = storeCode;
    data['store_name'] = storeName;
    return data;
  }
}
