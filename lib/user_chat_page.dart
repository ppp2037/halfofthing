import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halfofthing/user_board_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'background_page.dart';
import 'settings/styles.dart';
import 'survey_page.dart';

class User_Chat_Page extends StatefulWidget {
  User_Chat_Page({Key key}) : super(key: key);
  @override
  _User_Chat_PageState createState() => _User_Chat_PageState();
}

class _User_Chat_PageState extends State<User_Chat_Page> {
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  String _userPhoneNumber;
  String _chattingRoomID;
  bool _userIsHost = true; // 사용자가 채팅방 개설자인지
  String _otherPhoneNumber; // 상대방의 핸드폰번호
  var _enteredTime;
  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        print("UserPhone : $_userPhoneNumber");
      });
    })();
  }

  Widget timeStampText(DocumentSnapshot documentSnapshot) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    DateTime date = documentSnapshot.data['time'].toDate();
    var diff = date.difference(now);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = '' + format.format(date);
    } else {
      if (diff.inDays == 1) {
        time = '어제 ' + format.format(date);
      } else {
        time = diff.inDays.toString() + '일 전';
      }
    }
    return Text(
      time,
      style: text_grey_10(),
    );
  }

  Widget deliveredIcon(DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data['delivered']
        ? Container()
        : Icon(
            Icons.fiber_manual_record,
            color: Colors.orange,
            size: 15,
          );
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    // 나의 말풍선
    return <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          timeStampText(documentSnapshot),
          deliveredIcon(documentSnapshot),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.pink,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(documentSnapshot.data['sender_nickname'],
                      style: text_white_15()),
                  Container(
                    height: 5,
                  ),
                  Text(
                    documentSnapshot.data['text'],
                    style: text_white_15(),
                  ),
                ],
              ),
            ),
          )
        ],
      )
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    // 상대방의 말풍선
    documentSnapshot.reference.updateData({'delivered': true});
    return <Widget>[
      new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(documentSnapshot.data['sender_nickname'],
                        style: text_black_15()),
                    Container(
                      height: 5,
                    ),
                    Text(
                      documentSnapshot.data['text'],
                      style: text_black_15(),
                    ),
                  ],
                ),
              ),
            ),
            timeStampText(documentSnapshot)
          ])
    ];
  }

  List<Widget> generateNoticeLayout(DocumentSnapshot documentSnapshot) {
    // 공지 말풍선
    documentSnapshot.reference.updateData({'delivered': true});
    return <Widget>[
      new Row(children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Column(
              children: <Widget>[
                Text(
                  documentSnapshot.data['text'],
                  style: text_black_15(),
                ),
              ],
            ),
          ),
        ),
        // timeStampText(documentSnapshot)
      ])
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (_userIsHost) {
      // 개설자인 경우 : 메세지 전체 출력
      return snapshot.data.documents
          .map<Widget>((doc) => doc.data['sender_phone'] == '공지'
              ?
              // 공지 메세지인 경우
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: generateNoticeLayout(doc),
                  ),
                )
              : doc.data['sender_phone'] != _userPhoneNumber
                  ?
                  // 상대방이 보낸 메세지인 경우
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: generateReceiverLayout(doc),
                      ),
                    )
                  :
                  // 자신이 보낸 메세지인 경우
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: generateSenderLayout(doc),
                      ),
                    ))
          .toList();
    } else {
      // 참가자인 경우 : 참여시간 이후의 메세지만 출력
      return snapshot.data.documents
          .map<Widget>((doc) =>
              (doc.data['time'].toDate().difference(_enteredTime).inSeconds) > 0
                  // 메세지 받은 시간 - 참여시간 > 0 인 경우에만 출력
                  ? doc.data['sender_phone'] != _userPhoneNumber
                      ?
                      // 상대방이 보낸 메세지인 경우
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: generateReceiverLayout(doc),
                          ),
                        )
                      :
                      // 자신이 보낸 메세지인 경우
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: generateSenderLayout(doc),
                          ),
                        )
                  : Container())
          .toList();
    }
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
          _chattingRoomID = snapshot_user.data['채팅중인방ID'];
          chatReference = Firestore.instance
              .collection("채팅")
              .document(_chattingRoomID)
              .collection('messages');
          if (_chattingRoomID == '') {
            // 사용자가 채팅중인 방이 없을 경우
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => Background_Page()))),
                backgroundColor: Colors.white10,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '현재 진행중인 반띵이 없어요',
                    style: text_grey_15(),
                  ),
                  Container(
                    height: 60,
                  ),
                  Text(
                    '왼쪽 다른 반띵에 참가하거나',
                    style: text_grey_15(),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    '가운데 시작을 눌러 반띵을 시작해보세요',
                    style: text_grey_15(),
                  ),
                ],
              ),
            );
          } else {
            // 사용자가 채팅중인 방이 있을 경우 => 채팅중인 방으로 연결
            return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('게시판')
                    .document(_chattingRoomID)
                    .snapshots(),
                builder: (context, snapshot_board) {
                  if (!snapshot_board.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  // 사용자가 채팅방의 개설자인지 참여자인지 구분, 상대방 핸드폰번호 저장
                  if (snapshot_board.data['개설자핸드폰번호'] == _userPhoneNumber) {
                    _userIsHost = true;
                    _otherPhoneNumber = snapshot_board.data['참가자핸드폰번호'];
                  } else {
                    _userIsHost = false;
                    _otherPhoneNumber = snapshot_board.data['개설자핸드폰번호'];
                  }

                  if (snapshot_board.data['참여시간'] != '') {
                    _enteredTime = DateTime.parse(snapshot_board.data['참여시간']);
                  }
                  return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Background_Page()))),
                      title: Text(
                        _userIsHost && _otherPhoneNumber == ''
                            ? '참여중인 사람이 없어요 ㅜ.ㅜ'
                            : '반띵을 완료하면 우측상단 완료를 눌러주세요',
                        style: text_grey_15(),
                      ),
                      // automaticallyImplyLeading: false,
                      backgroundColor: Colors.white10,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black),
                    ),
                    endDrawer: Drawer(
                      child: _userIsHost && _otherPhoneNumber == ''
                          // 자신이 개설자인데 참가자가 없을 경우
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                  ListTile(
                                      leading: Icon(
                                        Icons.restaurant,
                                        color: Colors.grey,
                                      ),
                                      title: Text('게시물 삭제하기',
                                          style: text_grey_20()),
                                      onTap: () {
                                        // 게시물 삭제
                                        snapshot_user.data.reference
                                            .updateData({'채팅중인방ID': ''});
                                        snapshot_board.data.reference.delete();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Background_Page()));
                                      })
                                ])
                          : StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('사용자')
                                  .document(_otherPhoneNumber)
                                  .snapshots(),
                              builder: (context, snapshot_other_user) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // 채팅중인 상대방이 있을 경우
                                      ListTile(
                                          leading: Icon(
                                            Icons.account_circle,
                                            color: Colors.grey,
                                          ),
                                          title: Text(
                                              '상대방 반띵 횟수 : ' +
                                                  snapshot_other_user
                                                      .data['이용횟수']
                                                      .toString(),
                                              style: text_grey_20())),
                                      Container(
                                        height: 40,
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.restaurant,
                                          color: Colors.grey,
                                        ),
                                        title: Text('반띵 완료하기',
                                            style: text_grey_20()),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Survey_Page()));
                                        },
                                      ),
                                      Container(
                                        height: 40,
                                      ),
                                      _userIsHost
                                          ?
                                          // 자신이 방 개설자인 경우
                                          ListTile(
                                              leading: Icon(
                                                Icons.clear,
                                                color: Colors.grey,
                                              ),
                                              title: Text('참가자 내보내기',
                                                  style: text_grey_20()),
                                              onTap: () {
                                                snapshot_other_user
                                                    .data.reference
                                                    .updateData(
                                                        {'채팅중인방ID': ''});
                                                snapshot_board.data.reference
                                                    .updateData({
                                                  '참가자핸드폰번호': '',
                                                  '참여시간': ''
                                                });
                                                chatReference.add({
                                                  'text': '상대방을 내보냈습니다.',
                                                  'sender_phone': '공지',
                                                  'sender_nickname': "",
                                                  'time': DateTime.now(),
                                                  'delivered': false,
                                                });
                                                Navigator.pop(context);
                                              },
                                            )
                                          :
                                          // 자신이 방 참가자인 경우
                                          ListTile(
                                              leading: Icon(
                                                Icons.clear,
                                                color: Colors.grey,
                                              ),
                                              title: Text('다른 반띵하기',
                                                  style: text_grey_20()),
                                              onTap: () {
                                                snapshot_user.data.reference
                                                    .updateData(
                                                        {'채팅중인방ID': ''});
                                                chatReference.add({
                                                  'text': '상대방이 반띵을 취소하였습니다.',
                                                  'sender_phone': '공지',
                                                  'sender_nickname': "",
                                                  'time': DateTime.now(),
                                                  'delivered': true,
                                                });
                                                snapshot_board.data.reference
                                                    .updateData({
                                                  '참가자핸드폰번호': '',
                                                  '참여시간': ''
                                                });
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Background_Page()));
                                              },
                                            ),
                                    ]);
                              }),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection("채팅")
                                .document(snapshot_user.data['채팅중인방ID'])
                                .collection('messages')
                                .orderBy('time', descending: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                    child: CircularProgressIndicator());
                              return Expanded(
                                child: ListView(
                                  reverse: true,
                                  children: generateMessages(snapshot),
                                ),
                              );
                            },
                          ),
                          Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.white,
                              child: _buildTextComposer()),
                        ],
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: <Widget>[
          Flexible(
              child: _userIsHost && _otherPhoneNumber == ''
                  // 내가 개설한 채팅방에 참여중인 사람이 없으면 텍스트 입력 disable
                  ? TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    )
                  : TextField(
                      style: text_black_15(),
                      controller: _textController,
                      onChanged: (String messageText) {
                        setState(() {
                          _isWritting = messageText.length > 0;
                        });
                      },
                      onSubmitted: _sendText,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    )),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isWritting ? Colors.pink : Colors.grey,
            ),
            onPressed:
                _isWritting ? () => _sendText(_textController.text) : null,
          ),
        ],
      ),
    );
  }

  Future<Null> _sendText(String text) async {
    if (text.isNotEmpty) {
      _textController.clear();
      chatReference.add({
        'text': text,
        'sender_phone': _userPhoneNumber,
        'sender_nickname': "사용자",
        'time': DateTime.now(),
        'delivered': false,
      }).then((documentReference) {
        setState(() {
          _isWritting = false;
        });
      }).catchError((e) {});
    }
  }
}
