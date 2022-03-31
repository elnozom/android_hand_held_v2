class InsertPrepareItemResp {
  late bool prepared;
  late double qntPrepared;
  late double qnt;
  late bool headPrepared;
  InsertPrepareItemResp(
      {
      required this.prepared,
      required this.qntPrepared,
      required this.qnt,
      required this.headPrepared,
   });

  InsertPrepareItemResp.fromJson(Map<String, dynamic> json) {
    prepared = json['Prepared'];
    qntPrepared = json['QntPrepared'] is int ? json['QntPrepared'].toDouble() : json['QntPrepared'] ;
    qnt = json['Qnt'] is int ? json['Qnt'].toDouble() : json['Qnt'];
    headPrepared = json['HeadPrepared'];
  }

  
}
