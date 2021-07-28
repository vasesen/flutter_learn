import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RankingPage extends StatefulWidget {
  RankingPage({Key? key}) : super(key: key);

  @override
  _RankingPageState createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('排行榜'),
      ),
      body: Container(
        child: Text('排行榜'),
      ),
    );
  }
}
