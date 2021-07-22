// 创建页面
import 'package:bilibili_app/page/detail.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/login_page.dart';
import 'package:bilibili_app/page/register_page.dart';
import 'package:flutter/material.dart';

pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

//获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

// 路由封装 路由状态
enum RouteStatus { login, register, home, detail, unknow }

//获取page对应的routestatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegisterPage) {
    return RouteStatus.register;
  } else if (page.child is DetailPage) {
    return RouteStatus.detail;
  } else if (page.child is HomePage) {
    return RouteStatus.home;
  } else {
    return RouteStatus.unknow;
  }
}

//路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

// 监听路由页面跳转  监听当前页面是否压后台
class RouteNavigator extends _RouteJumpListener {
  static RouteNavigator? _instance;

  RouteJumpListener? _routeJump;
  RouteNavigator._();
  static RouteNavigator getInstance() {
    if (_instance == null) {
      _instance = RouteNavigator._();
    }
    return _instance!;
  }

  // 注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump!.onJumpTo(routeStatus, args: args);
  }
}

abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

//定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;
  RouteJumpListener({required this.onJumpTo});
}
