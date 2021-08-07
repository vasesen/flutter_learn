import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/widget/va_banner.dart';
import 'package:flutter/cupertino.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({Key? key, this.name, this.bannerList}) : super(key: key);
  final String? name;
  final List<BannerMo>? bannerList;

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [
        // dart collection if
        if (widget.bannerList != null) _banner(widget.bannerList!)
      ],
    ));
  }

  _banner(List<BannerMo> bannerList) {
    return VaBanner(
      bannerList,
      padding: EdgeInsets.only(left: 5, right: 5),
    );
  }
}
