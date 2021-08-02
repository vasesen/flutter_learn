import 'package:bilibili_app/model/home_mo.dart';
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
    return Container(child: Text(widget.name.toString()));
  }
}
