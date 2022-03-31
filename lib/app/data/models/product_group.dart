class ProductGroup {
  late int maxCode;
  late String groupName;
  ProductGroup(
      {
      required this.maxCode,
      required this.groupName});
  ProductGroup.fromJson(Map<String, dynamic> json) {
    maxCode = json['MaxCode'];
    groupName = json['GroupName'];
  }

  
}
