import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'user_board_page.dart';
import 'user_chat_page.dart';
import 'user_create_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

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
  ];

  String _userPhoneNumber;
  String _chattingRoomID;
  int unreadMessages = 0;

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
      });
    })();
  }

  void _onItemTapped(int index) {
    if(index == 2) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => User_Chat_Page()));
    } else{
      setState(() {
        _selectedIndex = index;
      });
    }
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
    return StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('users')
                .document(_userPhoneNumber)
                .snapshots(),
            builder: (context, snapshot_user) {
              if (!snapshot_user.hasData) {
                return Container();
              }
              _chattingRoomID = snapshot_user.data['chattingRoomId'];
              return Scaffold(
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
            });
  }

  Widget calculateUnreadMessages(BuildContext context) {
    // _chattingRoomID !=''일 경우에만 수행
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('board')
            .document(_chattingRoomID)
            .snapshots(),
        builder: (context, snapshot_board) {
          if (!snapshot_board.hasData) return Icon(Icons.chat);
          var onValue2 = FirebaseDatabase.instance
              .reference()
              .child("chatting")
              .child(_chattingRoomID)
              .orderByChild("delivered")
              .equalTo(false)
              .onValue;
          return StreamBuilder(
              stream: onValue2,
              builder: (context, AsyncSnapshot<Event> snap) {
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  Map<dynamic, dynamic> map = snap.data.snapshot.value;
                  List<dynamic> list = map.values
                      .where((element) =>
                  element['sender_phone'] != _userPhoneNumber)
                      .toList();
                  if (list.length.toString() == '0') {
                    return Icon(Icons.chat);
                  }
                  return Badge(
                      animationType: BadgeAnimationType.slide,
                      shape: BadgeShape.circle,
                      position: BadgePosition.topRight(top: -15),
                      badgeColor: Colors.pink,
                      badgeContent: Text(
                        list.length.toString(),
                        style: text_white_15(),
                      ),
                      child: Icon(Icons.chat));
                } else {
                  return Icon(Icons.chat);
                }
              });

        });
  }
}
