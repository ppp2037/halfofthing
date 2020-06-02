import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'select_page.dart';
import 'settings/styles.dart';
import 'user_chat_page.dart';

enum menus {
  submenu1,
  submenu2,
  submenu3,
  submenu4,
  submenu5,
  submenu6,
  submenu7
} //우측상단 팝업

class User_Main_Page extends StatefulWidget {
  @override
  _User_Main_PageState createState() => _User_Main_PageState();
}

class _User_Main_PageState extends State<User_Main_Page> {

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
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
        actions: <Widget>[
          PopupMenuButton<menus>(
            icon: Icon(Icons.list),
            onSelected: (menus result) {
              if (result == menus.submenu1) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu1()));
              } else if (result == menus.submenu2) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu2()));
              } else if (result == menus.submenu3) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
              } else if (result == menus.submenu4) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
              } else if (result == menus.submenu5) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
              } else if (result == menus.submenu6) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
              } else if (result == menus.submenu7) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<menus>>[
              PopupMenuItem<menus>(
                value: menus.submenu1,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu2,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu3,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu4,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu5,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu6,
                child: Row(
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
              ),
              PopupMenuItem<menus>(
                value: menus.submenu7,
                child: Row(
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
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('건국대학교_게시판')
            .where('거래완료', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.documents.isEmpty)
            return Center(
                child: Text(
                  '대기중인 사람이 없어요',
                  style: TextStyle(color: Colors.brown),
                  textScaleFactor: 1.2,
                ));
          return _buildList(context, snapshot.data.documents);
        },
      ),
//    ListView(
//        children: <Widget>[
//          GestureDetector(
//            onTap: () {
//              Chatstart(context);
//            },
//            child: Padding(
//              padding: const EdgeInsets.all(10),
//              child: Card(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.circular(20)),
//                elevation: 15,
//                child: Padding(
//                  padding: const EdgeInsets.all(20),
//                  child: Center(child: Column(
//                    children: <Widget>[
//                      Text('18:00 주문'),
//                      Container(
//                        height: 10,
//                      ),
//                      Text('맘스터치 건대점'),
//                    ],
//                  )),
//                ),
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(10),
//            child: Card(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(20)),
//              elevation: 15,
//              child: Padding(
//                padding: const EdgeInsets.all(20),
//                child: Center(child: Column(
//                  children: <Widget>[
//                    Text('19:00 주문'),
//                    Container(
//                      height: 10,
//                    ),
//                    Text('세종원 건대점'),
//                  ],
//                )),
//              ),
//            ),
//          ),
//          Padding(
//            padding: const EdgeInsets.all(10),
//            child: Card(
//              shape: RoundedRectangleBorder(
//                  borderRadius: BorderRadius.circular(20)),
//              elevation: 15,
//              child: Padding(
//                padding: const EdgeInsets.all(20),
//                child: Center(child: Column(
//                  children: <Widget>[
//                    Text('20:00 주문'),
//                    Container(
//                      height: 10,
//                    ),
//                    Text('엽떡 건대점'),
//                  ],
//                )),
//              ),
//            ),
//          )
//        ],
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Select_Page()));
        },
        child: Icon(Icons.add),
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
Widget Chatstart(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '메뉴 :',
                    style: TextStyle(color: Colors.brown),
                    textScaleFactor: 1,
                  ),
                  Container(
                    width: 10,
                  ),
                ],
              ),
              Container(
                height: 40,
              ),
              Text(
                '반띵을 시작하시겠습니까?',
                style: TextStyle(color: Colors.brown),
                textScaleFactor: 1,
              ),
              Container(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(bottom: 20.0),
    children: snapshot
        .map((data) => _buildListItem(context, data))
        .toList(),
  );
}

Widget _buildListItem(
    BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  String _userOrderDate = '';
  int _checkedMenu;
  int _total;

  return GestureDetector(
    onTap: () {
      Chatstart(context);
    },
    child: Padding(
      key: ValueKey(record.ordername),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      record.ordername,
                      style: text_grey_20(),
                    ),
                    record.orderisnow == 'Y' ?
                    Icon(Icons.check, color: Colors.pink,):Container()
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      record.ordermenu,
                      style: text_grey_20()
                    ),
                  ],
                ),
              ],
            ),
          )),
    ),
  );
}

class Record {
  final String ordername;
  final String ordermenu;
  final String orderisnow;
//  final String orderrequest;
//  final String ordertime;
//  final String orderid;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['주문메뉴'] != null),
        assert(map['주문시간'] != null),
        assert(map['인증'] != null),
//        assert(map['요청사항'] != null),
//        assert(map['주문시간'] != null),
//        assert(map['주문번호'] != null),
        ordername = map['주문메뉴'],
        ordermenu = map['주문시간'],
        orderisnow = map['인증']
//        orderrequest = map['요청사항'],
//        ordertime = map['주문시간'],
//        orderid = map['주문번호']
  ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$ordername:$ordermenu:$orderisnow>";
}
