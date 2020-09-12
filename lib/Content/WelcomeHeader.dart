import 'package:board/Content/MyUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  Header({this.screenWidth});
  final double screenWidth;

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  double szDP = 500;
  bool buttonHovered = false;

  @override
  Widget build(BuildContext context) {
    var mqd = MediaQuery.of(context);
    return AnimatedContainer(
        width: widget.screenWidth,
        height: dp2px(szDP, mqd),
        color: Color.fromARGB(255, 38, 21, 140),
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        child: Center(
            child: Material(
                color: Color.fromARGB(255, 38, 21, 140),
                child: InkWell(
                    child: Container(
                      padding: EdgeInsets.all(dp2px(150, mqd)),
                      child: Text('WELCOME',
                          style: TextStyle(
                              fontSize: dp2px(100, mqd),
                              color: buttonHovered
                                  ? Color.fromARGB(255, 130, 91, 251)
                                  : Color.fromARGB(255, 0, 252, 234))),
                    ),
                    hoverColor: Color.fromARGB(255, 0, 174, 158),
                    splashColor: Colors.transparent,
                    onHover: (hover) {
                      setState(() {
                        buttonHovered = hover;
                      });
                    }))));
  }
}
