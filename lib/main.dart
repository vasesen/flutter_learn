import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/page/detail.dart';
import 'package:bilibili_app/page/home_page.dart';
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
    var widget = Router(routerDelegate: _routeDelegate);
    return MaterialApp(home: widget);
  }
}

class MyRouteDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  MyRoutePath? path;
  List<MaterialPage> pages = [
    pageWrap(DetailPage(
      videoModel: null,
    )),
    pageWrap(
      HomePage(
        onJumpToDetail: (VideoModel value) {
          print('1:$value');
        },
      ),
    ),
  ];

  // 为navigator设置一个key 必要时可以通过 navigatorKey.currentState来获取到NavigatorState对象
  MyRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  // @override
  // GlobalKey<NavigatorState> get(navigatorKey) => throw UnimplementedError();

  @override
  Future<void> setNewRoutePath(MyRoutePath path) {
    throw UnimplementedError();
  }

  Widget build(BuildContext context) {
    //navigatorKey.currentState
    return Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          return true;
        });
  }
}

class MyRoutePath {
  final String? location;
  MyRoutePath.home() : location = "/";
  MyRoutePath.detail() : location = '/detail';
}

// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
