import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'settings/styles.dart';
import 'user_chat_page.dart';

class User_Board_Page extends StatefulWidget {
  @override
  _User_Board_PageState createState() => _User_Board_PageState();
}

class _User_Board_PageState extends State<User_Board_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
