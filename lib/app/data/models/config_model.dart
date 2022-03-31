class Config {
  int? trSerial;
  int? type;
  int? accType;
  int? docNo;
  int? accSerial;
  String? accName;
  int? toStore;
  int? sessionNo;
  int? headSerial;
  bool? partInv;

  Config(
      {this.trSerial,
      this.type,
      this.accType,
      this.docNo,
      this.accSerial,
      this.accName,
      this.toStore,
      this.sessionNo,
      this.headSerial,
      this.partInv
      });
}
