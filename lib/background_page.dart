import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';

import 'user_board_page.dart';
import 'user_chat_page.dart';
import 'user_create_page.dart';

class Background_Page extends StatefulWidget {
  @override
  _Background_PageState createState() => _Background_PageState();
}

class _Background_PageState extends State<Background_Page> {
  DateTime currentBackPressTime; //두번 눌러 종료하기 변수

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    User_Board_Page(),
    User_Create_page(),
    User_Chat_Page(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: '한번 더 누르면 종료됩니다');
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return _selectedIndex == 2
        ? Scaffold(body: _widgetOptions[_selectedIndex])
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: WillPopScope(
              child: Center(
                child: _widgetOptions[_selectedIndex],
              ),
              onWillPop: onWillPop,
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.library_books), title: Text('게시판')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), title: Text('시작')),
                BottomNavigationBarItem(
                    icon: Badge(
                        animationType: BadgeAnimationType.scale,
                        shape: BadgeShape.circle,
                        position: BadgePosition.topRight(top: -15),
                        badgeColor: Colors.pink,
                        badgeContent: Text(
                          '3',
                          style: text_white_15(),
                        ),
                        child: Icon(Icons.chat)),
                    title: Text('채팅')),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.pink,
              selectedIconTheme: IconThemeData(size: 35),
              onTap: _onItemTapped,
            ),
          );
  }
}
