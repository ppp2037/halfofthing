import 'package:flutter/material.dart';

class User_Setting_Page extends StatefulWidget {
  @override
  _User_Setting_PageState createState() => _User_Setting_PageState();
}

class _User_Setting_PageState extends State<User_Setting_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '내 정보',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.location_on,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '이용기록',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.library_books,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '이용방법',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.notifications,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '공지사항',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '신고하기',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.help_outline,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '고객지원',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
                Container(
                  width: 10,
                ),
                Text(
                  '설정',
                  style: TextStyle(color: Colors.grey),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}
