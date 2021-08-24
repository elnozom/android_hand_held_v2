class Emp {
  late String empName;
  late int empCode;
  late String empPassword;

  Emp({
    required this.empName, required this.empCode, required this.empPassword
    });

  Emp.fromJson(Map<String, dynamic> json) {
    empName = json['EmpName'];
    empCode = json['EmpCode'];
    empPassword = json['EmpPassword'];
  }
}
