import 'dart:convert';

class RegisterDev {
  final String? dfid;

  RegisterDev({this.dfid});

  factory RegisterDev.fromMap(Map<String, dynamic> json) {
    return RegisterDev(dfid: json['dfid']);
  }
  Map<String, dynamic> toMap() {
    return {'dfid': dfid};
  }

  String toJson() {
    return json.encode(toMap());
  }
}
