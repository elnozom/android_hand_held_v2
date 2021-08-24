class DocItem {
  late int serial;
  late int qnt;
  late int itemBarCode;
  late int minorPerMajor;
  late String itemName;
  late bool byWeight;

  DocItem(
      {
      required this.serial,
      required this.qnt,
      required this.itemBarCode,
      required this.minorPerMajor,
      required this.itemName,
      required this.byWeight});

  DocItem.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    qnt = json['Qnt'];
    itemBarCode = json['Item_BarCode'];
    minorPerMajor = json['MinorPerMajor'];
    itemName = json['ItemName'];
    byWeight = json['ByWeight'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Serial'] = serial;
    data['Qnt'] = qnt;
    data['Item_BarCode'] = itemBarCode;
    data['MinorPerMajor'] = minorPerMajor;
    data['ItemName'] = itemName;
    data['ByWeight'] = byWeight;
    return data;
  }
}
