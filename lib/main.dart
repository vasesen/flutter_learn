import 'package:bilibili_app/db/cache.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/route_navigator.dart';
import 'package:bilibili_app/page/detail.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MyRouteDelegate _routeDelegate = MyRouteDelegate();
  @override
  Widget build(BuildContext context) {
    //var widget = Router(routerDelegate: _routeDelegate);
    //return MaterialApp(home: widget);
    return FutureBuilder<Cache>(
        // 进行初始化
        future: Cache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<Cache> snapshot) {
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: Colors.blue),
          );
        });
  }
}

class MyRouteDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  //MyRoutePath? path;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  RouteStatus _routeStatus = RouteStatus.login;
  // 为navigator设置一个key 必要时可以通过 navigatorKey.currentState来获取到NavigatorState对象
  MyRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    //实现路由跳转逻辑
    RouteNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (_routeStatus == RouteStatus.detail) {
        print(args);
        //this.videoModel = args['videoMo'];
      }
      notifyListeners();
    }));
  }

  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.register && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    } else {
      return _routeStatus;
    }
  }

  bool get hasLogin => LoginDao.getBoardingPass() != null;
  @override
  Future<void> setNewRoutePath(MyRoutePath path) async {
    //this.path = path;
  }

  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
      //这里要求栈中只允许有一个同样的页面实例
      tempPages = tempPages.sublist(0, index);
    }

    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其它页面进行出栈 首页不可回退
      pages.clear();
      page = pageWrap(HomePage(
          //   onJumpToDetail: (VideoModel value) {
          //   this.videoModel = value;
          //   notifyListeners();
          // }
          ));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage(
        onJumpToRigister: () {
          _routeStatus = RouteStatus.register;
          notifyListeners();
        },
        onLoginSuccess: () {
          _routeStatus = RouteStatus.home;
          notifyListeners();
        },
      ));
      notifyListeners();
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(DetailPage(videoModel: this.videoModel));
      notifyListeners();
    }

    tempPages = [...tempPages, page];
    pages = tempPages;

    // 安卓物理返回键监听
    return WillPopScope(
      child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              //登录页未登录返回拦截
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showWarnToast('请先登录');
                  return false;
                }
              }
            }
            // 执行返回操作
            if (!route.didPop(result)) {
              return false;
            }
            pages.removeLast(); // 栈顶页面进行移除
            return true;
          }),
      onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
    );
  }
}

class MyRoutePath {
  final String? location;
  MyRoutePath.home() : location = "/";
  MyRoutePath.detail() : location = '/detail';
}
