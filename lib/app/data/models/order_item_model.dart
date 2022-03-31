class OrderItem {
  late int serial;
  late int barCode;
  late String itemName;
  late double qnt;
  late double qntAntherUnit;
  late double price;
  late double total;
  OrderItem(
      {
      required this.serial,
      required this.barCode,
      required this.itemName,
      required this.qnt,
      required this.qntAntherUnit,
      required this.price,
      required this.total});
  OrderItem.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    barCode = json['BarCode'];
    itemName = json['ItemName'];
    qnt = json['Qnt'] is int ? json['Qnt'].toDouble() : json['Qnt'];
    qntAntherUnit = json['qntAntherUnit'] is int ? json['qntAntherUnit'].toDouble() : json['qntAntherUnit'];
    price = json['Price'] is int ? json['Price'].toDouble() : json['Price'];
    total = json['Total'] is int ? json['Total'].toDouble() : json['Total'];
  }

  
}
