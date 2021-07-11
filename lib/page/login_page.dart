import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;
  LoginPage({Key? key, required this.onJumpToLogin}) : super(key: key);

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
      appBar: appBar('登录', '注册', rightButtonClick),
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
              padding: EdgeInsets.only(top: 20, left: 20, right: 200),
              child: _loginButton(),
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

  _loginButton() {
    return InkWell(
      onTap: () {
        // 注册事件
        print('tap:${userName.isNotEmpty}');
        _send();
      },
      child: Text(
        '登录',
      ),
    );
  }

  void _send() async {
    var result = await LoginDao.login(userName, password);
    print(result);
  }
}
