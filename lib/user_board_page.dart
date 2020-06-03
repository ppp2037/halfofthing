import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/styles.dart';
import 'user_chat_page.dart';

class User_Board_Page extends StatefulWidget {
  @override
  _User_Board_PageState createState() => _User_Board_PageState();
}

class _User_Board_PageState extends State<User_Board_Page> {

  String _userPhoneNumber;
  String _userLocation;

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        _userLocation = prefs.getString('prefsLocation');
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('게시판')
            .where('위치', isEqualTo: _userLocation)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.documents.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '반띵중인 사람이 없어요',
                  style: text_grey_15()
                ),
                Container(
                  height: 20,
                ),
                Text(
                    '시작을 눌러 반띵을 시작해보세요',
                    style: text_grey_15()
                ),
              ],
            );
          return _buildList(context, snapshot.data.documents);
        },
      ),
    );
  }
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '식당 : ' + record.restaurant,
                    style: text_pink_20()
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                      '시간 : ' + record.time,
                      style: text_pink_20()
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    '반띵을 시작하시겠습니까?',
                    style: text_grey_15()
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
                                style: text_grey_15()
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
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
                                style: text_grey_15()
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
    },
    child: Padding(
      key: ValueKey(record.phoneNumber),
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
                      record.restaurant,
                      style: text_grey_20(),
                    ),
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        record.time,
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
  final String phoneNumber;
  final String restaurant;
  final String time;
  final String location;
//  final String orderrequest;
//  final String ordertime;
//  final String orderid;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['핸드폰번호'] != null),
        assert(map['식당이름'] != null),
        assert(map['주문시간'] != null),
        assert(map['위치'] != null),
//        assert(map['요청사항'] != null),
//        assert(map['주문시간'] != null),
//        assert(map['주문번호'] != null),
        phoneNumber = map['핸드폰번호'],
        restaurant = map['식당이름'],
        time = map['주문시간'],
        location = map['위치']
//        orderrequest = map['요청사항'],
//        ordertime = map['주문시간'],
//        orderid = map['주문번호']
      ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$phoneNumber:$restaurant:$time:$location>";
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
