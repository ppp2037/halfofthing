import 'package:flutter/material.dart';

class User_Settings_Notice_page extends StatefulWidget {
  @override
  _User_Settings_Notice_pageState createState() =>
      _User_Settings_Notice_pageState();
}

class _User_Settings_Notice_pageState extends State<User_Settings_Notice_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공지사항'),
      ),
      body: Center(child: Text('공지사항')),
    );
  }
}
