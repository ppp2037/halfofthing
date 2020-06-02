import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';

class Add_Account_Page extends StatefulWidget {
  @override
  _Add_Account_PageState createState() => _Add_Account_PageState();
}

class _Add_Account_PageState extends State<Add_Account_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text('반가워요', style: text_grey_15(),))
        ],
      ),
    );
  }
}
