import 'package:flutter/material.dart';

class User_Settings_PersonalInfo_Page extends StatefulWidget {
  @override
  _User_Settings_PersonalInfo_PageState createState() => _User_Settings_PersonalInfo_PageState();
}

class _User_Settings_PersonalInfo_PageState extends State<User_Settings_PersonalInfo_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인정보 처리방침'),
        centerTitle: true,
      ),
      body: Center(child: Text('개인정보 처리방침')),
    );
  }
}
