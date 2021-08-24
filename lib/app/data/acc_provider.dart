import 'package:elnozom_pda/app/data/models/acc_model.dart';
import 'package:elnozom_pda/app/data/models/emp_model.dart';
import 'package:get/get.dart';
import 'package:elnozom_pda/app/data/models/config_cache_model.dart';
import 'package:elnozom_pda/app/controllers/global_controller.dart';

class AccProvider extends GetConnect {
  @override
  ConfigCache config = ConfigCache();
  
  Future<List<Acc>> getAccount(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await post('${config.server}get-account', data);
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      List<Acc> accs = [];
      if(response.body != null) response.body.forEach((item){
        Acc acc = Acc.fromJson(item);
        accs.add(acc);
      });
      // print(accs);
      return accs;
    }
  }
  Future<Emp?> getEmp(Map data) async {
    config = await GlobalController().getConfigCache();
    final response = await get('${config.server}employee?EmpCode=${data["EmpCode"]}');
    if (response.status.hasError) {
      return Future.error(response.statusText.toString());
    } else {
      Emp? emp = response.body != null ? Emp.fromJson(response.body[0]) : null;
      return emp;
    }
  }
}
