import 'package:flutter/cupertino.dart';

abstract class MonitorState<T extends StatefulWidget> extends State<T> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      print('state:页面销毁，本次setState不执行: ${toString()}');
    }
  }
}
