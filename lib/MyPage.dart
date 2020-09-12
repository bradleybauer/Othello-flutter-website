import 'package:board/Content/MyUtil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'Content/Othello/UI/GameView.dart';
import 'Content/WelcomeHeader.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData queryData = MediaQuery.of(context);
    final double screenWidth = queryData.size.width;
    final double screenHeight = queryData.size.height;

    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Header(screenWidth: screenWidth),
        ClipRect(
          clipBehavior: Clip.hardEdge,
          child: Container(
              width: screenWidth,
              height: screenHeight * 1.1,
              child: GameView(screenWidth: screenWidth, screenHeight: screenHeight * 1.1),
              color: Colors.black),
        ),
        Container(
          alignment: Alignment.center,
          height: dp2px(400, queryData),
          width: screenWidth,
          color: Colors.blue,
          child: Text('More content to come', style: TextStyle(fontSize: dp2px(32, queryData))),
        ),
      ],
    );

    return SingleChildScrollView(child: content);
  }
}
