import 'package:bilibili_app/model/video_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final VideoModel? videoModel;
  //const DetailPage(this.videoModel);

  DetailPage({Key? key, this.videoModel}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情页'),
      ),
      body: Container(
        child: Text('详情页,vid:${widget.videoModel!.vid}'),
      ),
    );
  }
}
