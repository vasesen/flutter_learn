import 'package:bilibili_app/model/video_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.onJumpToDetail}) : super(key: key);
  final ValueChanged<VideoModel> onJumpToDetail;
  @override
  _HomePageState createState() => _HomePageState();
}

void onJumpToDetail() {
  VideoModel(15);
}

class _HomePageState extends State<HomePage> {
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
              onPressed: onJumpToDetail)
        ],
      )),
    );
  }
}
