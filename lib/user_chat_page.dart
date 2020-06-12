import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'background_page.dart';
import 'settings/styles.dart';
import 'survey_page.dart';

class User_Chat_Page extends StatefulWidget {
  final String boardName;
  User_Chat_Page({Key key, this.boardName}) : super(key: key);
  @override
  _User_Chat_PageState createState() => _User_Chat_PageState();
}

class _User_Chat_PageState extends State<User_Chat_Page> {
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  String _userPhoneNumber;
  String _chattingRoomID;
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
    // FIXME: toDate() 값이 null 인 비동기 문제:  'toDate' was called on null => Fixed
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

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>((doc) => doc.data['sender_phone'] != _userPhoneNumber
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: generateReceiverLayout(doc),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: generateSenderLayout(doc),
                ),
              ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          _chattingRoomID = snapshot.data['채팅중인방ID'];
          chatReference = Firestore.instance
              .collection("채팅")
              .document(_chattingRoomID)
              .collection('messages');
          return _chattingRoomID == ''
              ? Column(
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
                )
              : Scaffold(
                  appBar: AppBar(
                    title: Text(
                      '반띵을 완료하면 우측상단 완료를 눌러주세요',
                      style: text_grey_15(),
                    ),
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white10,
                    elevation: 0,
                    iconTheme: IconThemeData(color: Colors.black),
                  ),
                  endDrawer: Drawer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.account_circle,
                            color: Colors.grey,
                          ),
                          title: Text(
                              '상대방 반띵 횟수 : ' + snapshot.data['이용횟수'].toString(),
                              style: text_grey_20()),
                        ),
                        Container(
                          height: 40,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.restaurant,
                            color: Colors.grey,
                          ),
                          title: Text('반띵 완료하기', style: text_grey_20()),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Survey_Page()));
                          },
                        ),
                        Container(
                          height: 40,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                          title: Text('다른 반띵하기', style: text_grey_20()),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Background_Page()));
                          },
                        ),
                      ],
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection("채팅")
                              .document(snapshot.data['채팅중인방ID'])
                              .collection('messages')
                              .orderBy('time', descending: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Center(child: CircularProgressIndicator());
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

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
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
            ),
          ),
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
        'sender_nickname': "랜덤",
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
