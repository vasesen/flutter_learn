import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool protect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', rightButtonClick),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: '用户名',
              hint: "请输入用户名",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                print(text);
              },
            ),
            LoginInput(
              title: '密码',
              hint: "请输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                print(text);
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void rightButtonClick() {
    print('1');
  }
}
