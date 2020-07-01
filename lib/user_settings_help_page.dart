import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';

class User_Settings_Help_Page extends StatefulWidget {
  @override
  _User_Settings_Help_PageState createState() =>
      _User_Settings_Help_PageState();
}

class _User_Settings_Help_PageState extends State<User_Settings_Help_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('고객지원', style: text_pink_20(),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text('고객지원 문의사항'),
            ),
          ],
        ),
      ),
    );
  }
}
