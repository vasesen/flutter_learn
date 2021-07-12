import 'package:bilibili_app/db/cache.dart';
import 'package:bilibili_app/http/core/net.dart';
import 'package:bilibili_app/http/request/base_request.dart';
import 'package:bilibili_app/http/request/login_request.dart';
import 'package:bilibili_app/http/request/register_request.dart';
import 'dart:convert';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";
  static login(String userName, String password) {
    return _send(userName, password);
  }

  static register(
      String userName, String password, String imoocId, String orderId) {
    return _send(userName, password, imoocId: imoocId, orderId: orderId);
  }

  static _send(String userName, String password, {imoocId, orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegisterRequest();
      request
          .add("userName", userName)
          .add("password", password)
          .add("imoocId", imoocId) //4095046
          .add("orderId", orderId); //3327
    } else {
      request = LoginRequest();
      request.add("userName", userName).add("password", password);
    }
    print(request.header);
    var result = await Net.getInstance().fire(request);
    var data = jsonDecode(result.toString());
    if (data['code'] == 0 && data['data'].isNotEmpty) {
      //保存登录令牌
      Cache.getInstance().setString("BOARDING_PASS", data['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return Cache.getInstance().get("BOARDING_PASS");
  }
}
