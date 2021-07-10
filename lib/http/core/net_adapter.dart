import 'dart:convert';

import 'package:bilibili_app/http/request/base_request.dart';

abstract class NetAdapter {
  Future<NetResponse<T>> send<T>(BaseRequest request);
}

class NetResponse<T> {
  NetResponse(
      {this.data,
      this.request,
      this.statusCode,
      this.statusMessage,
      this.extra});

  dynamic data;
  BaseRequest? request;
  int? statusCode;
  String? statusMessage;
  dynamic extra;

  @override
  String toString() {
    if (data is Map) {
      return json.encode(data);
    }
    return data.toString();
  }
}
