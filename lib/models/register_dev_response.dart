class RegisterDevResponse {
  final String? dfid;

  RegisterDevResponse({this.dfid});

  factory RegisterDevResponse.fromJson(Map<String, dynamic> json) {
    return RegisterDevResponse(dfid: json['dfid'] as String?);
  }

  Map<String, dynamic> toJson() => {'dfid': dfid};
}
