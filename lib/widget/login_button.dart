import 'package:bilibili_app/util/color.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({
    Key? key,
    required this.title,
    this.enable = true,
    this.onPressed,
  }) : super(key: key);
  final String title;
  final bool enable;
  final VoidCallback? onPressed;

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 45,
        //onPressed: widget.enable ? widget.onPressed : null,
        onPressed: widget.onPressed,
        disabledColor: primary[50],
        color: primary,
        child: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
