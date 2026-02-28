class BaseApi<T> {
  final int? status;
  final int? errorCode;
  final T? data;

  BaseApi({this.status, this.errorCode, this.data});

  factory BaseApi.fromMap(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return BaseApi<T>(
      status: json['status'] as int?,
      errorCode: json['errorCode'] as int?,
      data: json['data'] == null ? null : fromJsonT(json['data']),
    );
  }
}
