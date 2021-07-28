import 'package:bilibili_app/model/video_model.dart';
import 'package:bilibili_app/navigator/route_navigator.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  //final ValueChanged<VideoModel> onJumpToDetail;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var listener;
  @override
  void initState() {
    super.initState();
    RouteNavigator.getInstance().addListtener(this.listener = (current, pre) {
      print('current:${current.page}');
      print('pre:${pre.page}');
      if (widget == current.page || current.page is HomePage) {
        print('当前页:onResume');
      } else if (widget == pre?.page || pre.page is HomePage) {
        print('首页：onPause 被压后台');
      }
    });
  }

  @override
  void dispose() {
    RouteNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Container(
          child: Column(
        children: [
          Text('首页'),
          MaterialButton(
              minWidth: 250,
              color: Colors.blue,
              child: (Text('button')),
              onPressed: () {
                RouteNavigator.getInstance().onJumpTo(
                  RouteStatus.detail,
                  args: {'videoMo': VideoModel(18)},
                );
              })
          //onPressed: () => widget.onJumpToDetail(VideoModel(18)))
        ],
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
