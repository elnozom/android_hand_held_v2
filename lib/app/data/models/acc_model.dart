class Acc {
  late int serial;
  late int accountCode;
  late String accountName;

  Acc({required this.serial, required this.accountCode, required this.accountName});

  Acc.fromJson(Map<String, dynamic> json) {
    serial = json['Serial'];
    accountCode = json['AccountCode'];
    accountName = json['AccountName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Serial'] = serial;
    data['AccountCode'] = accountCode;
    data['AccountName'] = accountName;
    return data;
  }
}
