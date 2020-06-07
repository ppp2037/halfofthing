import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bubble/bubble.dart';
import 'package:intl/intl.dart';

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

  String readTimestamp(Timestamp timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm');
    DateTime date = timestamp.toDate();
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
        time = diff.inDays.toString() + 'DAYS AGO';
      }
    }

    return time;
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
      new Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            readTimestamp(documentSnapshot.data['time']),
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
                fontStyle: FontStyle.italic),
          ),
          Bubble(
            style: styleMe,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(documentSnapshot.data['sender_nickname'],
                    style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(
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
    Timestamp ts = documentSnapshot.data['time'];
    DateTime d = ts.toDate();
    // print("timestamp : ${documentSnapshot.data['time']}");
    // print("date : ${d}");

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
            Text(
              readTimestamp(documentSnapshot.data['time']),
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic),
            ),
          ])
    ];
  }

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map<Widget>((doc) => Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: new Row(
                children: doc.data['sender_phone'] != _userPhoneNumber
                    ? generateReceiverLayout(doc)
                    : generateSenderLayout(doc),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String _chattingRoomID;

    return StreamBuilder<DocumentSnapshot>(
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
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
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
        });
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isWritting ? () => _sendText(_textController.text) : null,
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isWritting
              ? Theme.of(context).accentColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                  onSubmitted: _sendText,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  Future<Null> _sendText(String text) async {
    _textController.clear();
    chatReference.add({
      'text': text,
      'sender_phone': _userPhoneNumber,
      'sender_nickname': "랜덤",
      'time': DateTime.now(),
      'read': false,
    }).then((documentReference) {
      setState(() {
        _isWritting = false;
      });
    }).catchError((e) {});
  }
}
