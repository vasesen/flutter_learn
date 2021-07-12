import 'package:bilibili_app/http/dao/login_dao.dart';
import 'package:bilibili_app/widget/appbar.dart';
import 'package:bilibili_app/widget/login_effect.dart';
import 'package:bilibili_app/widget/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;
  RegisterPage({Key? key, required this.onJumpToLogin}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool protect = false;
  bool loginEnable = false;
  String userName = '';
  String passWord = '';
  String rePassWord = '';
  final String imoocId = "4095046";
  final String orderId = "3327";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage(
            onJumpToLogin: () {},
          );
        }));
      }),
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
                passWord = text;
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            LoginInput(
              title: '确认密码',
              hint: "请确认密码",
              lineStretch: true,
              obscureText: true,
              onChanged: (text) {
                rePassWord = text;
              },
              focusChanged: (focus) {},
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
    if (userName.isNotEmpty && passWord.isNotEmpty && rePassWord.isNotEmpty) {
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
        if (loginEnable == true) {
        } else {
          print('false');
        }
      },
      child: Text(
        '注册',
      ),
    );
  }

  void _send() async {
    var result = await LoginDao.register(userName, passWord, imoocId, orderId);
    print(result);
  }
}
