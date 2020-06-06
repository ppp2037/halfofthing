import 'package:flutter/material.dart';

class User_Settings_Howto_Page extends StatefulWidget {
  @override
  _User_Settings_Howto_PageState createState() => _User_Settings_Howto_PageState();
}

class _User_Settings_Howto_PageState extends State<User_Settings_Howto_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이용방법'),
      ),
      body: Center(child: Text('이용방법 스크린샷')),
    );
  }
}

