//import 'package:bilibili_app/http/core/mock_adapter.dart';
import 'package:bilibili_app/http/request/base_request.dart';

import 'dio_adapter.dart';
import 'net_adapter.dart';
import 'net_error.dart';

/* 
  什么是单例模式？
  确保某一个类只有一个实例，而且自行实例化并向整个系统提供这个实例，这个类称为单例类，单例模式是一种对象创建型模式。
  单例模式应用的场景有哪些，作用是什么？
  常见应用场景有：Windows的Task Manager（任务管理器）、Recycle Bin（回收站）、网站计数器
  总结：
  单例模式应用的场景一般发现在以下条件下：
  资源共享的情况下，避免由于资源操作时导致的性能问题或损耗等。如日志文件，应用配置。
  控制资源的情况下，方便资源之间的互相通信。如线程池等。
*/
class Net {
  Net._();
  static Net? _instance;
  static Net getInstance() {
    if (_instance == null) {
      _instance = Net._();
    }
    return _instance!;
  }
  // factory Net() => _getInstance();
  // static Net get instance => _getInstance();
  // static Net? _instance;
  // Net._internal();
  // static Net _getInstance() {
  //   if (_instance == null) {
  //     _instance = Net._internal();
  //   }
  //   return _instance!;
  // }

  Future fire(BaseRequest request) async {
    // var response = await send(request);
    // var result = response['data'];
    // return result;
    NetResponse? response;
    var error;
    try {
      response = await send(request);
    } on NetError catch (e) {
      error = e;
      response = e.data;
      print(e.message);
    }
    if (response == null) {
      print(error);
    }

    var result = response?.data;
    var status = response?.statusCode;
    switch (status) {
      case 200:
        return response;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw NetError(status!, result.toString(), data: result);
    }
  }

  Future<NetResponse<T>> send<T>(BaseRequest request) async {
    //print('url:${request.url()}');
    // print('method:${request.httpMethod()}');
    // request.addHeader("token", "12345");
    // print('header:${request.header}');
    // return Future.value({
    //   "statusCode": 200,
    //   "data": {"code": 1, "message": "success"}
    // });
    NetAdapter adapter = DioAdapter(); //切换环境
    return adapter.send(request);
  }

  void printLog(log) {
    print('net:${log.toString()}');
  }
}
