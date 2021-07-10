import 'dart:async';

import 'package:bilibili_app/http/core/net_adapter.dart';
import 'package:bilibili_app/http/request/base_request.dart';

class MockAdapter extends NetAdapter {
  @override
  Future<NetResponse<T>> send<T>(BaseRequest request) {
    return Future<NetResponse<T>>.delayed(Duration(milliseconds: 1000), () {
      //print(request.params);
      return NetResponse(
          data: {"code": 0, "message": "error"},
          statusCode: 401,
          request: null,
          statusMessage: '');
    });
  }
}
