import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_board_page.dart';
import 'user_chat_page.dart';
import 'user_create_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Background_Page extends StatefulWidget {
  @override
  _Background_PageState createState() => _Background_PageState();
}

class _Background_PageState extends State<Background_Page> {
  DateTime currentBackPressTime; //두번 눌러 종료하기 변수
  SharedPreferences prefs;
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    User_Board_Page(),
    User_Create_page(),
    User_Chat_Page(),
  ];

  String _userPhoneNumber;
  String _otherPhoneNumber;
  String _chattingRoomID;
  int unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    (() async {
      prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
      });
      print("background - userPhone : $_userPhoneNumber");
      await Firestore.instance
          .collection('사용자')
          .document(_userPhoneNumber)
          .get()
          .then((DocumentSnapshot ds) {
        _chattingRoomID = ds['채팅중인방ID'];
        print("background - chattingroom : $_chattingRoomID");
      }).catchError((onError) => print(onError));
      await Firestore.instance
          .collection('게시판')
          .document(_chattingRoomID)
          .get()
          .then((DocumentSnapshot ds) {
        if (_userPhoneNumber == ds['개설자핸드폰번호']) {
          _otherPhoneNumber = ds['참가자핸드폰번호'];
        } else {
          _otherPhoneNumber = ds['개설자핸드폰번호'];
        }
      }).catchError((onError) => print(onError));
      print("background - _otherPhoneNumber : $_otherPhoneNumber");
    })();
  }

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
    print(
        "background - build => UserPhone : $_userPhoneNumber, chattingroom : $_chattingRoomID, _otherPhoneNumber : $_otherPhoneNumber");
    return _selectedIndex == 2
        ? Scaffold(body: _widgetOptions[_selectedIndex])
        : _chattingRoomID == null
            ? Container()
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
                        icon: _chattingRoomID == ''
                            ? Icon(Icons.chat)
                            : calculateUnreadMessages(context),
                        title: Text('채팅')),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: Colors.pink,
                  selectedIconTheme: IconThemeData(size: 35),
                  onTap: _onItemTapped,
                ),
              );
  }

  Widget calculateUnreadMessages(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('게시판')
          .document(_chattingRoomID)
          .collection('messages')
          .where('sender_phone', isEqualTo: _otherPhoneNumber)
          .where('delivered', isEqualTo: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Icon(Icons.chat);
        if (snapshot.data.documents.length.toString() == '0')
          return Icon(Icons.chat);
        return Badge(
            animationType: BadgeAnimationType.slide,
            shape: BadgeShape.circle,
            position: BadgePosition.topRight(top: -15),
            badgeColor: Colors.pink,
            badgeContent: Text(
              snapshot.data.documents.length.toString(),
              style: text_white_15(),
            ),
            child: Icon(Icons.chat));
      },
    );
  }
}
