import 'dart:convert';

import 'package:bilibili_app/http/core/net_error.dart';
import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/util/toast.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_button.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onJumpToRigister;
  final VoidCallback onLoginSuccess;
  LoginPage(
      {Key? key, required this.onJumpToRigister, required this.onLoginSuccess})
      : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('登录', '注册', widget.onJumpToRigister),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: '用户名',
              hint: "请输入用户名",
              lineStretch: true,
              obscureText: false,
              onChanged: (text) {
                userName = text;
              },
            ),
            LoginInput(
              title: '密码',
              hint: "请输入密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                password = text;
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                  title: '登录', enable: loginEnable, onPressed: send),
            )
          ],
        ),
      ),
    );
  }

  void rightButtonClick() {
    print('1');
  }

  void checkInput() {
    bool enable = false;
    if (userName.isNotEmpty && password.isNotEmpty) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(userName, password);
      print(result);
      if (jsonDecode(result.toString())['code'] == 0) {
        showToast('登录成功');
        widget.onLoginSuccess();
      } else {
        showWarnToast(jsonDecode(result.toString())['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
    } on NetError catch (e) {
      print(e);
    }
  }
}
