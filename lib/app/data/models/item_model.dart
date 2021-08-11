class Item {
  int serial = 0;
  String itemName = "0";
  int minorPerMajor = 0;
  int pOSPP = 0;
  int pOSTP = 0;
  bool byWeight = false;
  bool withExp = false;
  bool itemHasAntherUnit = false;
  int avrWait = 0;
  String expirey = "0";

  Item(
      {
      required this.serial,
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
    minorPerMajor = json['MinorPerMajor'];
    pOSPP = json['POSPP'];
    pOSTP = json['POSTP'];
    byWeight = json['ByWeight'];
    withExp = json['WithExp'];
    itemHasAntherUnit = json['ItemHasAntherUnit'];
    avrWait = json['AvrWait'];
    expirey = json['Expirey'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Serial'] = serial;
    data['ItemName'] = itemName;
    data['MinorPerMajor'] = minorPerMajor;
    data['POSPP'] = pOSPP;
    data['POSTP'] = pOSTP;
    data['ByWeight'] = byWeight;
    data['WithExp'] = withExp;
    data['ItemHasAntherUnit'] = itemHasAntherUnit;
    data['AvrWait'] = avrWait;
    data['Expirey'] = expirey;
    return data;
  }
}
