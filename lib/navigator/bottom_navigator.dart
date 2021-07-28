import 'package:bilibili_app/navigator/route_navigator.dart';
import 'package:bilibili_app/page/favorite_page.dart';
import 'package:bilibili_app/page/home_page.dart';
import 'package:bilibili_app/page/profile_page.dart';
import 'package:bilibili_app/page/ranking_page.dart';
import 'package:bilibili_app/util/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavigator extends StatefulWidget {
  BottomNavigator({Key? key}) : super(key: key);

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = primary;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);
  List<Widget> _pages = [];
  bool _hasBuild = false;
  @override
  Widget build(BuildContext context) {
    _pages = [HomePage(), RankingPage(), FavoritePage(), ProfilePage()];
    if (!_hasBuild) {
      RouteNavigator.getInstance()
          .onBottomTabChange(0, _pages[0]); //初始化页面 homepage
      _hasBuild = true;
    }
    return Scaffold(
      body: PageView(
          controller: _controller,
          //children: [HomePage(), RankingPage(), FavoritePage(), ProfilePage()],
          children: _pages,
          // onPageChanged: (index) {
          //   setState(() {
          //     _currentIndex = index;
          //   });
          // },
          onPageChanged: (index) => _onJumpTo(index, pageChange: false),
          physics: NeverScrollableScrollPhysics()),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        // onTap: (index) {
        //   _controller.jumpToPage(index);
        //   setState(() {
        //     _currentIndex = index;
        //   });
        // },
        onTap: (index) => _onJumpTo(index, pageChange: false),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: _activeColor,
        items: [
          _bottomItem('首页', Icons.home, 0),
          _bottomItem('排行', Icons.local_fire_department, 1),
          _bottomItem('收藏', Icons.favorite, 2),
          _bottomItem('我的', Icons.live_tv, 3)
        ],
      ),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        label: title);
  }

  void _onJumpTo(int index, {pageChange = false}) {
    RouteNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    if (!pageChange) {
      // 让PageView展示对应tab
      _controller.jumpToPage(index);
    } else {
      RouteNavigator.getInstance().onBottomTabChange(index, _pages[index]);
    }
    setState(() {
      _currentIndex = index;
    });
  }
}
