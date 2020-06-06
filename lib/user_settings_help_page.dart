import 'package:flutter/material.dart';

class User_Settings_Help_Page extends StatefulWidget {
  @override
  _User_Settings_Help_PageState createState() => _User_Settings_Help_PageState();
}

class _User_Settings_Help_PageState extends State<User_Settings_Help_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('고객지원'),
      ),
      body: Center(child: Text('고객지원')),
    );
  }
}
