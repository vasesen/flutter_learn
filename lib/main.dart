import 'package:bilibili_app/db/cache.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/route_navigator.dart';
import 'package:bilibili_app/page/detail.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/login_page.dart';
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
       future:Cache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<Cache> snapshot)){
      var widget = snapshot.connectionState == ConnectionState.done ? Router(routerDelegate: _routeDelegate):Scaffold(body:Center(child: CircularProgressIndicator(),) ,);
      return MaterialApp(
        home: widget,
        theme: ThemeData(primarySwatch: Colors.white),
      );
    };

  }
}

class MyRouteDelegate extends RouterDelegate<MyRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<MyRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  //MyRoutePath? path;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  RouteStatus _routeStatus = RouteStatus.home;
  // 为navigator设置一个key 必要时可以通过 navigatorKey.currentState来获取到NavigatorState对象
  MyRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  RouteStatus get routeStatus {
    if(_routeStatus != RouteStatus.register&&!hasLogin){
      return _routeStatus = RouteStatus.login;
    }else if(videoModel !=null){
      return _routeStatus = RouteStatus.detail;
    }else {
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
    if(index != -1){
        // 要打开的页面在栈中已存在，则将该页面和它上面的所有页面进行出栈
        //这里要求栈中只允许有一个同样的页面实例
        tempPages = tempPages.sublist(0,index);
    }

    var page;
    if(routeStatus == RouteStatus.home){
      //跳转首页时将栈中其它页面进行出栈 首页不可回退
      pages.clear();
      page = pageWrap(HomePage(onJumpToDetail: (VideoModel value) {
        this.videoModel = value;
        notifyListeners();
      }));
    }else if(routeStatus == RouteStatus.login){
      page = pageWrap(LoginPage(onJumpToLogin: (){}));
    }

    tempPages = [...tempPages,page];
    pages = tempPages;
    //navigatorKey.currentState
    // pages = [
    //   pageWrap(HomePage(onJumpToDetail: (VideoModel value) {
    //     this.videoModel = value;
    //     print(this.videoModel!.vid);
    //     notifyListeners();
    //   })),
    //   if (this.videoModel != null)               
    //     pageWrap(DetailPage(
    //       videoModel: this.videoModel,
    //     ))
    // ];
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
