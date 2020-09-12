import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'MyPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0;
    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.black, body: Center(child: MyPage())),
    );
  }
}
