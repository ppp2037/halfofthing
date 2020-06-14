import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:halfofthing/settings/nickname_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/styles.dart';
import 'user_chat_page.dart';
import 'user_settings_feedback_page.dart';
import 'user_settings_help_page.dart';
import 'user_settings_howto_page.dart';
import 'user_settings_notice_page.dart';
import 'user_settings_personalinfo_page.dart';

class User_Board_Page extends StatefulWidget {
  @override
  _User_Board_PageState createState() => _User_Board_PageState();
}

class _User_Board_PageState extends State<User_Board_Page> {
  String _userPhoneNumber;
  String _userLocation;
  bool _isNotificationChecked = false;
  bool _userIsChatting = false; // 사용자가 기존에 참여하고 있는 채팅방이 있는지

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
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot_user) {
          if (!snapshot_user.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot_user.data['채팅중인방ID'] != '') {
            _userIsChatting = true;
          }
          return Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white10,
              elevation: 0,
              title: Text(
                '반띵',
                style: GoogleFonts.poorStory(color: Colors.pink, fontSize: 30),
              ),
            ),
            endDrawer: Drawer(
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
                            Text(snapshot_user.data['이름'],
                                style: text_white_20()),
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
                              snapshot_user.data['위치'],
                              style: text_white_20(),
                            ),
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.apps,
                              color: Colors.white,
                              size: 30,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text(
                              '이용횟수  :  ' +
                                  snapshot_user.data['이용횟수'].toString(),
                              style: text_white_20(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.library_books),
                    title: Text(
                      '이용방법',
                      style: text_grey_15(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Settings_Howto_Page()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(
                      '공지사항',
                      style: text_grey_15(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Settings_Notice_page()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text(
                      '개선사항',
                      style: text_grey_15(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Settings_Feedback_Page()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text(
                      '고객지원',
                      style: text_grey_15(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Settings_Help_Page()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_active),
                    title: Row(
                      children: <Widget>[
                        Text(
                          '푸시알림',
                          style: text_grey_15(),
                        ),
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
                    leading: Icon(Icons.lock),
                    title: Text(
                      '개인정보 처리방침',
                      style: text_grey_15(),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              User_Settings_PersonalInfo_Page()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.clear),
                    title: Text(
                      '로그아웃',
                      style: text_grey_15(),
                    ),
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
                  ListTile(
                    title: Column(
                      children: <Widget>[
                        Container(
                          height: 20,
                        ),
                        Text(
                          'Copyright © 2020 gauntlet Inc.',
                          style: text_grey_10(),
                        ),
                        Container(
                          height: 10,
                        ),
                        Text(
                          'All Rights Reserved. Ver 1.0.0',
                          style: text_grey_10(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('게시판')
                  .where('위치', isEqualTo: _userLocation)
                  .snapshots(),
              builder: (context, snapshot_board) {
                if (!snapshot_board.hasData)
                  return Center(child: CircularProgressIndicator());
                if (snapshot_board.data.documents.isEmpty)
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
                return _buildList(
                    context, snapshot_board.data.documents, _userPhoneNumber);
              },
            ),
          );
        });
  }

  Widget _buildList(
      BuildContext context, List<DocumentSnapshot> snapshot, _userPhoneNumber) {
    snapshot.sort((a, b) =>
        Record.fromSnapshot(a).time.compareTo(Record.fromSnapshot(b).time));

    return ListView(
      padding: const EdgeInsets.only(bottom: 20.0),
      children: snapshot
          .map((data) => _buildListItem(context, data, _userPhoneNumber))
          .toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data_board,
      String _userPhoneNumber) {
    final record = Record.fromSnapshot(data_board);
    String orderTimeStr = record.time.toString().substring(8, 10) +
        "시 " +
        record.time.toString().substring(10, 12) +
        "분";
    return GestureDetector(
      onTap: () {
        if (record.completed) {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
                return popUpDialog(context, "이미 반띵이 완료된 게시물이예요.");
              });
        } else if (_userPhoneNumber == record.phoneNumber ||
            _userPhoneNumber == record.phoneNumber2) {
          // 자신이 개설한 게시물인 경우 (나의 게시물) or 자신이 참여중인 게시물인 경우 (내가 참여중)
          // => 채팅방으로 바로 이동
          Navigator.of(context).pop();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => User_Chat_Page()));
        } else {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                if (_userIsChatting) {
                  // 사용자가 현재 채팅중일 경우 => 입장 불가 Dialog 띄우기
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                  return popUpDialog(context, "현재 진행중인 채팅방이 있기 때문에 입장하실 수 없어요");
                } else if (record.phoneNumber2 != '') {
                  // 다른 사람이 참여중인 게시물인 경우 (반띵중)
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                  return popUpDialog(context, "이미 반띵중인 게시물이예요.");
                } else if (record.blockedList.contains(_userPhoneNumber)) {
                  // 이미 내보낸 사용자인 경우 입장 불가
                  Future.delayed(Duration(seconds: 2), () {
                    Navigator.pop(context);
                  });
                  return popUpDialog(context, "님 차단당함 ^^");
                } else {
                  // 사용자가 현재 참여중인 채팅방이 없고, 게시물이 반띵중이 아닌 경우
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('식당 : ' + record.restaurant,
                            style: text_pink_20()),
                        Container(
                          height: 20,
                        ),
                        Text('시간 : ' + orderTimeStr, style: text_pink_20()),
                        Container(
                          height: 20,
                        ),
                        Text('장소 : ' + record.meetingPlace,
                            style: text_pink_20()),
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
                                // 게시물에 새로 참가하기
                                String nickName = randomNickname();
                                data_board.reference.updateData({
                                  '참가자핸드폰번호': _userPhoneNumber,
                                  '참가자참여시간': DateTime.now().toString(),
                                  '참가자닉네임': nickName,
                                });
                                data_board.reference
                                    .collection('messages')
                                    .add({
                                  'text': "$nickName 님이 입장하셨습니다.",
                                  'sender_phone': "공지",
                                  'sender_nickname': "",
                                  'time': DateTime.now(),
                                  'delivered': false,
                                });
                                Firestore.instance
                                    .collection('사용자')
                                    .document(_userPhoneNumber)
                                    .updateData({
                                  '채팅중인방ID': record.boardname,
                                });
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
                }
              });
        }
      },
      child: ListTile(
        title: Column(
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
                      record.completed
                          ? Text(
                              '완료된 게시글',
                              style: text_grey_15(),
                            )
                          : _userPhoneNumber == record.phoneNumber
                              ? Text(
                                  '나의 게시글',
                                  style: text_grey_15(),
                                )
                              : _userPhoneNumber == record.phoneNumber2
                                  ? Text(
                                      '내가 참여중',
                                      style: text_grey_15(),
                                    )
                                  : record.phoneNumber2 != ''
                                      // 참가자핸드폰번호에 누군가 있으면 반띵중 문구 표시
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
                      Text(orderTimeStr + '\t\t\t' + record.meetingPlace,
                          style: text_grey_20()),
                    ],
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

Widget popUpDialog(BuildContext context, String text) {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    content: SizedBox(width: 150, height: 80, child: new Text(text)),
  );
}

class Record {
  final String phoneNumber, phoneNumber2;
  final String restaurant, time, location, boardname, meetingPlace;
  final String enteredTime; // 참가자가 참여를 시작한 시간
  final String createdTime; // 생성시간
  final bool completed; // 완료된 게시물인지
  final DocumentReference reference;
  final List<dynamic> blockedList;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['개설자핸드폰번호'] != null),
        assert(map['참가자핸드폰번호'] != null),
        assert(map['식당이름'] != null),
        assert(map['주문시간'] != null),
        assert(map['위치'] != null),
        assert(map['만날장소'] != null),
        assert(map['게시판이름'] != null),
        assert(map['생성시간'] != null),
        phoneNumber = map['개설자핸드폰번호'],
        phoneNumber2 = map['참가자핸드폰번호'],
        restaurant = map['식당이름'],
        time = map['주문시간'],
        location = map['위치'],
        meetingPlace = map['만날장소'],
        boardname = map['게시판이름'],
        enteredTime = map['참가자참여시간'],
        createdTime = map['생성시간'],
        completed = (map['반띵완료_참가자'] as bool) && (map['반띵완료_개설자'] as bool),
        blockedList = map['내보낸사용자'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$phoneNumber:$phoneNumber2:$restaurant:$time:$location:$meetingPlace:$boardname>";
}
