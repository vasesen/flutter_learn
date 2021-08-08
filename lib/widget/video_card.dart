import 'package:bilibili_app/model/home_mo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatelessWidget {
  final VideoMo? videoMo;
  const VideoCard({Key? key, this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          print('点击视频封面');
        },
        child: Image.network(videoMo!.cover!),
      ),
    );
  }
}
