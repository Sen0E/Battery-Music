class ApiResponse<T> {
  final int? status;
  final int? errorCode;
  final T? data;
  ApiResponse({this.status, this.errorCode, this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse(
      status: json['status'], // 1 成功 0 失败
      errorCode: json['error_code'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
