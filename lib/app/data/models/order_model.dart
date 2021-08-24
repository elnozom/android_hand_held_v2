class Order {
  late String docNo;
  late String accountName;
  late int accountCode;

  Order(
      {
      required this.docNo,
      required this.accountName,
      required this.accountCode,
     });

  Order.fromJson(Map<String, dynamic> json) {
    docNo = json['DocNo'];
    accountName = json['AccountName'];
    accountCode = json['AccountCode'];
   
  }
}
