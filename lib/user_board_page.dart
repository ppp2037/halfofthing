import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
  bool _isNotificationChecked = false;

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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text(
          '반띵',
          style: GoogleFonts.poorStory(color: Colors.pink, fontSize: 30),
        ),
      ),
      endDrawer: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            Map<String, dynamic> documentFields = snapshot.data.data;
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.pink,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(snapshot.data['이름'], style: text_white_20()),
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(
                              snapshot.data['위치'],
                              style: text_white_20(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.apps),
                    title: Text('이용횟수  :  ' + snapshot.data['이용횟수'].toString(), style: text_grey_15(),),
                  ),
                  ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text('이용방법', style: text_grey_15(),),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('공지사항', style: text_grey_15(),),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('고객지원', style: text_grey_15(),),
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_active),
                    title: Row(
                      children: <Widget>[
                        Text('푸시알림',style: text_grey_15(),),
                        Container(
                          width: 30,
                        ),
                        Switch(
                          value: _isNotificationChecked,
                          onChanged: (value) {
                            setState(() {
                              _isNotificationChecked = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text('로그아웃',style: text_grey_15(),),
                    onTap: () {
                      (() async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                        setState(() {
                          prefs.clear();
                        });
                      })();
                      Fluttertoast.showToast(
                          msg: '로그아웃 되었습니다',
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white);
                      Phoenix.rebirth(context);
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('게시판')
            .where('위치', isEqualTo: _userLocation)
            .orderBy('생성시간')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.documents.isEmpty)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('반띵중인 사람이 없어요', style: text_grey_15()),
                Container(
                  height: 20,
                ),
                Text('가운데 시작을 눌러 반띵을 시작해보세요', style: text_grey_15()),
              ],
            );
          return _buildList(context, snapshot.data.documents, _userPhoneNumber);
        },
      ),
    );
  }
}

Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot, _userPhoneNumber) {
  return ListView(
    padding: const EdgeInsets.only(bottom: 20.0),
    children: snapshot
        .map((data) => _buildListItem(context, data, _userPhoneNumber))
        .toList(),
  );
}

Widget _buildListItem(
    BuildContext context, DocumentSnapshot data, String _userPhoneNumber) {
  final record = Record.fromSnapshot(data);

  return GestureDetector(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('식당 : ' + record.restaurant, style: text_pink_20()),
                  Container(
                    height: 20,
                  ),
                  Text('시간 : ' + record.time, style: text_pink_20()),
                  Container(
                    height: 20,
                  ),
                  Text('장소 : ' + record.meetingPlace, style: text_pink_20()),
                  Container(
                    height: 20,
                  ),
                  Text('반띵을 시작하시겠어요?', style: text_grey_15()),
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
                              child: Text('취소', style: text_grey_15()),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (record.ischat != 'Y') {
                            if (record.phoneNumber != _userPhoneNumber) {
                              Firestore.instance
                                  .collection('게시판')
                                  .document(record.boardname)
                                  .updateData({
                                '참가자핸드폰번호': _userPhoneNumber,
                              });
                              Firestore.instance
                                  .collection('채팅')
                                  .document(record.boardname)
                                  .collection('messages');
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => User_Chat_Page(
                                        boardName: record.boardname,
                                        isOrderer: false,
                                      )));
                            } else {
                              Firestore.instance
                                  .collection('게시판')
                                  .document(record.boardname)
                                  .updateData({
                                '참가자핸드폰번호': _userPhoneNumber,
                              });
                              Firestore.instance
                                  .collection('채팅')
                                  .document(record.boardname)
                                  .collection('messages');
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => User_Chat_Page(
                                        boardName: record.boardname,
                                        isOrderer: true,
                                      )));

                              // Navigator.of(context).pop();
                              // Fluttertoast.showToast(
                              //     msg: '나의 게시판이에요',
                              //     gravity: ToastGravity.CENTER,
                              //     backgroundColor: Colors.pink,
                              //     textColor: Colors.white);
                            }
                          } else {
                            Navigator.of(context).pop();
                            Fluttertoast.showToast(
                                msg: '이미 반띵중이에요',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          }
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
                              child: Text('확인', style: text_grey_15()),
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
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    record.restaurant,
                    style: text_grey_20(),
                  ),
                  record.phoneNumber == _userPhoneNumber
                      ? Text(
                          '내가 참여중',
                          style: text_grey_15(),
                        )
                      : record.ischat == 'Y'
                          ? Text(
                              '반띵중',
                              style: text_grey_15(),
                            )
                          : Container(),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(record.time + ' ' + record.meetingPlace,
                      style: text_grey_20()),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    ),
  );
}

class Record {
  final String phoneNumber;
  final String phoneNumber2;
  final String restaurant;
  final String time;
  final String location;
  final String boardname;
  final String ischat;
  final String meetingPlace;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['개설자핸드폰번호'] != null),
        assert(map['참가자핸드폰번호'] != null),
        assert(map['식당이름'] != null),
        assert(map['주문시간'] != null),
        assert(map['위치'] != null),
        assert(map['만날장소'] != null),
        assert(map['게시판이름'] != null),
        assert(map['채팅중'] != null),
        phoneNumber = map['개설자핸드폰번호'],
        phoneNumber2 = map['참가자핸드폰번호'],
        restaurant = map['식당이름'],
        time = map['주문시간'],
        location = map['위치'],
        meetingPlace = map['만날장소'],
        boardname = map['게시판이름'],
        ischat = map['채팅중'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$phoneNumber:$phoneNumber2:$restaurant:$time:$location:$meetingPlace:$boardname:$ischat>";
}
