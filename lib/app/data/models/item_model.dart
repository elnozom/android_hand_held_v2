class Item {
  late int serial;
  late String itemName;
  late int minorPerMajor;
  late double pOSPP;
  late double pOSTP;
  late bool byWeight;
  late bool withExp;
  late bool itemHasAntherUnit;
  late double avrWait;
  late String expirey;

  Item(
      {required this.serial,
      required this.itemName,
      required this.minorPerMajor,
      required this.pOSPP,
      required this.pOSTP,
      required this.byWeight,
      required this.withExp,
      required this.itemHasAntherUnit,
      required this.avrWait,
      required this.expirey});

  Item.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    itemName = json['ItemName'];
    pOSPP = json['POSPP'] is int ? json['POSPP'].toDouble() : json['POSPP'];
    minorPerMajor = json['MinorPerMajor'];
    byWeight = json['ByWeight'];
    withExp = json['WithExp'];
    itemHasAntherUnit = json['ItemHasAntherUnit'];
    expirey = json['Expirey'];
  }
}
