import 'package:bilibili_app/http/core/net.dart';
import 'package:bilibili_app/http/request/home_rquest.dart';
import 'package:bilibili_app/model/home_mo.dart';

class HomeDao {
  static get(String categoryName, {int pageIndex = 1, int pageSize = 1}) async {
    HomeRequest request = HomeRequest();
    request.pathParams = categoryName;
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await Net.getInstance().fire(request);
    print('首页$result');
    return HomeMo.fromJson(result['data']);
  }
}
