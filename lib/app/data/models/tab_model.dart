import 'package:flutter/widgets.dart';

class TabModel {
  IconData? icon;
  String? text;
  String? link;
  int? transSerial;
  int? accountType;
  int? type;

  TabModel(
      {this.icon,
      this.text,
      this.link,
      this.transSerial,
      this.accountType,
      this.type});

  TabModel.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    text = json['text'];
    link = json['link'];
    transSerial = json['transSerial'];
    accountType = json['accountType'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['icon'] = icon;
    data['text'] = text;
    data['link'] = link;
    data['transSerial'] = transSerial;
    data['accountType'] = accountType;
    data['type'] = type;
    return data;
  }
}
