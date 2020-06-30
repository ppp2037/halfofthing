import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';

class User_Settings_Howto_Page extends StatefulWidget {
  @override
  _User_Settings_Howto_PageState createState() => _User_Settings_Howto_PageState();
}

class _User_Settings_Howto_PageState extends State<User_Settings_Howto_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('이용방법', style: text_pink_20(),),
        iconTheme: IconThemeData(color: Colors.pink),
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(child: Text('이용방법 스크린샷')),
    );
  }
}

