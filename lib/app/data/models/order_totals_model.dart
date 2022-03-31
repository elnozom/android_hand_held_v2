class OrderTotals {
  late int totalPackages;
  late double totalCash;
  late int serial;
  OrderTotals(
      {
      required this.totalPackages,
      required this.totalCash,
      required this.serial});
  OrderTotals.fromJson(Map<String, dynamic> json) {
    totalPackages = json['TotalPackages'];
    totalCash = json['TotalCash'] is int ? json['TotalCash'].toDouble() : json['TotalCash'];
    serial = json['Serial'];
  }

  
}
