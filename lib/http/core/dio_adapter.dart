import 'package:bilibili_app/http/core/net_adapter.dart';
import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:dio/dio.dart';

class DioAdapter extends NetAdapter {
  @override
  Future<NetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.PUT) {
        response = await Dio()
            .put(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }

    if (error != null) {
      throw NetError(response?.statusCode ?? -1, error.toString(),
          data: buildRes(response, request));
    }

    return buildRes(response, request);
  }

  dynamic buildRes(Response response, BaseRequest request) {
    return NetResponse(
        data: response.data,
        request: request,
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        extra: response);
  }
}
