class Doc {
  late int docNo;
   int? storeCode;
   int? accontSerial;
   int? transSerial;
  late String accountName;
   int? accountCode;

  Doc(
      {
      required this.docNo,
      this.storeCode,
      this.accontSerial,
      this.transSerial,
      required this.accountName,
      this.accountCode});

  Doc.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    storeCode = json['StoreCode'];
    accontSerial = json['AccontSerial'];
    transSerial = json['TransSerial'];
    accountName = json['AccountName'];
    accountCode = json['AccountCode'];
  }
}
