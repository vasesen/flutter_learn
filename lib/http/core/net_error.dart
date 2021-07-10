//implements 接口实现 关键词
// Exception 异常
class NetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  NetError(this.code, this.message, {this.data});
}

class NeedAuth extends NetError {
  NeedAuth(String message, {int code: 403, dynamic data})
      : super(code, message, data: data);
}

class NeedLogin extends NetError {
  NeedLogin({int code: 401, String message: '请先登录'}) : super(code, message);
}
