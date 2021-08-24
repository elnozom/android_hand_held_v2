import 'package:elnozom_pda/app/data/models/prepare_item_model.dart';

class PrepareConfig {
  int empCode;
  int hSerial;
  List<PrepareItem> invoice;
  PrepareConfig(
      {
      required this.empCode,
      required this.hSerial,
      required this.invoice,
      });
}
