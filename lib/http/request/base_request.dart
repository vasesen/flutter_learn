import 'package:bilibili_app/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE, PUT }

//基础请求
abstract class BaseRequest {
  var pathParams;
  var useHttps = true;
  String authority() {
    return 'api.devio.org'; // 域名设置
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    if (pathParams != null) {
      path().endsWith("/")
          ? pathStr = "${path()}$pathParams"
          : pathStr = "${path()}/$pathParams";
    }

    //HTTP 和 HTTP
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();

  Map<String, String> params = Map();
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    "course-flag": 'fa',
    'auth-token': 'ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa',
    'boarding-pass': LoginDao.getBoardingPass()
  };

  BaseRequest addHeader(String k, Object v) {
    params[k] = v.toString();
    return this;
  }
}
