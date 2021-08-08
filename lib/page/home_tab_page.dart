import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/home_dao.dart';
import 'package:bilibili_app/model/home_mo.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/va_banner.dart';
import 'package:bilibili_app/widget/video_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({Key? key, this.categoryName, this.bannerList}) : super(key: key);
  final String? categoryName;
  final List<BannerMo>? bannerList;

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoMo> videoList = [];
  int pageIndex = 1;
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //     child: ListView(
    //   children: [
    //     // dart collection if
    //     if (widget.bannerList != null) _banner(widget.bannerList!)
    //   ],
    // ));
    return MediaQuery.removeViewPadding(
      context: context,
      removeTop: true,
      child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: videoList.length,
          itemBuilder: (BuildContext context, int index) {
            if (widget.bannerList != null && index == 0) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: _banner(widget.bannerList!),
              );
            } else {
              return VideoCard(videoMo: videoList[index]);
            }
          },
          staggeredTileBuilder: (int index) {
            if (widget.bannerList != null && index == 0) {
              return StaggeredTile.fit(2);
            } else {
              return StaggeredTile.fit(1);
            }
          }),
    );
  }

  _banner(List<BannerMo> bannerList) {
    return VaBanner(
      bannerList,
      padding: EdgeInsets.only(left: 5, right: 5),
    );
  }

  void _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }

    var currentIndex = pageIndex + (loadMore ? 1 : 0);

    try {
      HomeMo result = await HomeDao.get(widget.categoryName.toString(),
          pageIndex: currentIndex, pageSize: 10);
      print('loadData():$result');
      setState(() {
        if (loadMore) {
          videoList = [...videoList, ...result.videoList!];
          if (result.videoList!.isNotEmpty) {
            pageIndex++;
          }
        } else {}
        videoList = result.videoList!;
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    } on NetError catch (e) {
      showWarnToast(e.message);
    }
  }
}
