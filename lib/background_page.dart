import 'package:flutter/material.dart';

import 'settings/styles.dart';
import 'user_board_page.dart';
import 'user_main_page.dart';

class Background_Page extends StatefulWidget {
  @override
  _Background_PageState createState() => _Background_PageState();
}

class _Background_PageState extends State<Background_Page> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    User_Board_Page(),
    User_Main_Page(),
    Text(
      'Index 1: Business',
    ),
    Text(
      'Index 2: School',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/halfofthing_logo_white_1024x1024.png',
            height: 40,
          ),
          Container(
            width: 10,
          ),
          Text(
            '반띵',
            style: text_white_20(),
          ),
        ],
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books),
              title: Text('게시판')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('시작')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('프로필')
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: _onItemTapped,
      ),
    );
  }
}
