import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble/bubble.dart';
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
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm');
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
      style: TextStyle(
          color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
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
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleMe = BubbleStyle(
      alignment: Alignment.topRight,
      nip: BubbleNip.rightTop,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      nipWidth: 10,
    );

    return <Widget>[
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          timeStampText(documentSnapshot),
          deliveredIcon(documentSnapshot),
          Bubble(
            style: styleMe,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(documentSnapshot.data['sender_nickname'],
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    documentSnapshot.data['text'],
                  ),
                ),
              ],
            ),
          )
        ],
      )
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    // 상대방의 말풍선
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0),
      alignment: Alignment.topLeft,
    );
    documentSnapshot.reference.updateData({'delivered': true});
    return <Widget>[
      new Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Bubble(
              style: styleSomebody,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(documentSnapshot.data['sender_nickname'],
                      style: new TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(documentSnapshot.data['text']),
                  ),
                ],
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
    return Scaffold(
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
//            snapshot.data['핸드폰번호']
            return Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    title: Text(
                        '상대방 반띵 횟수 : ' + snapshot.data['이용횟수'].toString(),
                        style: text_grey_20()),
                  ),
                  ListTile(
                    title: Text('반띵 완료하기', style: text_grey_20()),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Survey_Page()));
                    },
                  ),
                  ListTile(
                    title: Text('다른 반띵하기', style: text_grey_20()),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Background_Page()));
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('사용자')
              .document(_userPhoneNumber)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              _chattingRoomID = snapshot.data['채팅중인방ID'];
              chatReference = Firestore.instance
                  .collection("채팅")
                  .document(_chattingRoomID)
                  .collection('messages');

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white10,
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.pink),
                ),
                body: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.yellow.withAlpha(64),
                  child: new Column(
                    children: <Widget>[
                      StreamBuilder<QuerySnapshot>(
                        stream: chatReference
                            .orderBy('time', descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) return new Text("No Chat");
                          return Expanded(
                            child: new ListView(
                              reverse: true,
                              children: generateMessages(snapshot),
                            ),
                          );
                        },
                      ),
                      new Divider(height: 1.0),
                      new Container(
                        decoration: new BoxDecoration(
                            color: Theme.of(context).cardColor),
                        child: _buildTextComposer(),
                      ),
                      new Builder(builder: (BuildContext context) {
                        return new Container(width: 0.0, height: 0.0);
                      })
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }

  IconButton getDefaultSendButton() {
    return IconButton(
      icon: Icon(Icons.send),
      onPressed: _isWritting ? () => _sendText(_textController.text) : null,
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
        data: IconThemeData(
          color: _isWritting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                  onSubmitted: _sendText,
                  decoration:
                      InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
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
