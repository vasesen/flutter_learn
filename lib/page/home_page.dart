//import 'package:bilibili_app/model/video_model.dart';
//import 'package:bilibili_app/db/cache.dart';
import 'package:bilibili_app/http/core/monitor_state.dart';
import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/navigator/route_navigator.dart';
import 'package:bilibili_app/page/home_tab_page.dart';
import 'package:bilibili_app/util/color.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;
  HomePage({Key? key, this.onJumpTo}) : super(key: key);
  //final ValueChanged<VideoModel> onJumpToDetail;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends MonitorState<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  var listener;
  late TabController _tabController;
  //var tabs = ['推荐', '热门', '追播', '影视', '日常', '综合'];
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categoryList.length, vsync: this);
    RouteNavigator.getInstance().addListtener(this.listener = (current, pre) {
      print('current:${current.page}');
      print('pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('当前页:onResume');
      } else if (widget == pre?.page || pre.page is HomePage) {
        print('首页：onPause 被压后台');
      }
    });
    loadData();
  }

  @override
  void dispose() {
    RouteNavigator.getInstance().removeListener(this.listener);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Column(
      children: [
        NavigationBar(
          height: 50,
          child: _appBar(),
          color: Colors.white,
          statusStyle: StatusStyle.DARK_CONTENT,
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 50),
          child: _tabBar(),
        ),
        Flexible(
            child: TabBarView(
                controller: _tabController,
                children: categoryList.map((tab) {
                  return HomeTabPage(
                    //name: tab.name,
                    bannerList: tab.name == '推荐' ? bannerList : null,
                  );
                }).toList()))
      ],
    ));
  }

  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Colors.black,
        indicator: UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primary, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
              child: Padding(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: Text(
                    tab.name.toString(),
                    style: TextStyle(fontSize: 16),
                  )));
        }).toList());
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get('推荐');
      print('loadData():$result');
      if (result.categoryList != null) {
        _tabController =
            TabController(length: result.categoryList!.length, vsync: this);
      }
      setState(() {
        categoryList = result.categoryList!;
        bannerList = result.bannerList!;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      showWarnToast(e.message);
    }
  }

  _appBar() {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              //print('跳转到我的页面');
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image(
                height: 46,
                width: 46,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                decoration: BoxDecoration(color: Colors.grey[100]),
              ),
            ),
          )),
          Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
