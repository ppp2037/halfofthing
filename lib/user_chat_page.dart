import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'background_page.dart';
import 'settings/styles.dart';
import 'survey_page.dart';
import 'dart:io';

class User_Chat_Page extends StatefulWidget {
  @override
  _User_Chat_PageState createState() => _User_Chat_PageState();
}

class _User_Chat_PageState extends State<User_Chat_Page> {
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  String _userPhoneNumber,
      _userLocation,
      _otherPhoneNumber = '',
      _myNickname,
      _otherNickname,
      _chattingRoomID = '',
      _myOrders,
      _otherOrders;
  var _enteredTime;
  bool _userIsHost = true; // 사용자가 채팅방 개설자인지
  bool _myCompleted = false, _otherCompleted = false; // 나와 상대방의 반띵완료 클릭 여부 저장
  List<dynamic> blockList;
  var _orderTime;
  String _restaurant, _meetingPlace;
  AsyncSnapshot<DocumentSnapshot> userSnapshot,
      otherUserSnapshot,
      boardSnapshot;
  @override
  void initState() {
    super.initState();

    // for push notification
    registerNotification();
    configLocalNotification();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        _userLocation = prefs.getString('prefsLocation');
      });
    })();
  }

  Widget timeStampText(DocumentSnapshot documentSnapshot) {
    var now = DateTime.now();
    var format = DateFormat('H:mm');
    DateTime date = (documentSnapshot.data['time']).toDate();
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
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            documentSnapshot.data['sender_nickname'],
            style: text_black_15(),
          ),
          Container(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              timeStampText(documentSnapshot),
              deliveredIcon(documentSnapshot),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.pink,
                child: Container(
                  constraints: BoxConstraints(minWidth: 10, maxWidth: 250),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    documentSnapshot.data['text'],
                    style: text_white_15(),
                  ),
                ),
              ),
            ],
          ),
        ],
      )
    ];
  }

  Future readOtherMessages() {
    return Firestore.instance.runTransaction((Transaction transaction) async {
      await Firestore.instance
          .collection("board")
          .document(_chattingRoomID)
          .collection("messages")
          .where("sender_phone", isEqualTo: _otherPhoneNumber)
          .where("delivered", isEqualTo: false)
          .snapshots()
          .forEach((snapshot) {
        snapshot.documents.forEach((document) {
          transaction.update(document.reference, {"delivered": true});
        });
      });
      // print("readOtherMessages");
    });
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    // 상대방의 말풍선
    if (documentSnapshot.data['delivered'] as bool == false) {
      documentSnapshot.reference.updateData({'delivered': true});
      // Firestore.instance.runTransaction((transaction) async {
      //   await transaction
      //       .update(documentSnapshot.reference, {'delivered': true});
      // });
      print(
          "delivered update : ${documentSnapshot.data['text']} from ${documentSnapshot.data['sender_phone']}");
    }
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(documentSnapshot.data['sender_nickname'],
              style: text_black_15()),
          Container(
            height: 5,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Container(
                constraints: BoxConstraints(minWidth: 10, maxWidth: 250),
                padding: EdgeInsets.all(10),
                child: Text(
                  documentSnapshot.data['text'],
                  style: text_black_15(),
                ),
              ),
            ),
            timeStampText(documentSnapshot)
          ]),
        ],
      )
    ];
  }

  List<Widget> generateNoticeLayout(DocumentSnapshot documentSnapshot) {
    // 공지 말풍선
    documentSnapshot.reference.updateData({'delivered': false});
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
    // readOtherMessages();
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
              ((doc.data['time']).toDate().difference(_enteredTime).inSeconds) >
                      0
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
    print(
        "build => chattingRoom : $_chattingRoomID, userIsHost : $_userIsHost, userphone : $_userPhoneNumber, otherPhone : $_otherPhoneNumber");
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          this.userSnapshot = userSnapshot;
          if (userSnapshot.data['채팅중인방ID'] == '') {
            // 사용자가 채팅중인 방이 없을 경우
            return noChattingRoom(context);
          } else {
            // 채팅중인 방이 있을 경우
            _chattingRoomID = userSnapshot.data['채팅중인방ID'];
            _myOrders = userSnapshot.data['이용횟수'].toString();
            return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('board')
                    .document(userSnapshot.data['채팅중인방ID'])
                    .snapshots(),
                builder: (context, boardSnapshot) {
                  if (!boardSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  this.boardSnapshot = boardSnapshot;
                  chatReference =
                      boardSnapshot.data.reference.collection("messages");
                  _restaurant = boardSnapshot.data['식당이름'];
                  _orderTime = boardSnapshot.data['주문시간'];
                  _meetingPlace = boardSnapshot.data['만날장소'];
                  // 사용자가 채팅방의 개설자인지 참여자인지 구분, 자신과 상대방 정보 저장
                  blockList = List.from(boardSnapshot.data['내보낸사용자']);
                  if (_userPhoneNumber == boardSnapshot.data['개설자핸드폰번호']) {
                    _userIsHost = true;
                    _myNickname = boardSnapshot.data['개설자닉네임'];
                    if ((_otherPhoneNumber = boardSnapshot.data['참가자핸드폰번호']) !=
                        '') {
                      _otherNickname = boardSnapshot.data['참가자닉네임'];
                      _myCompleted = boardSnapshot.data['반띵완료_개설자'] as bool;
                      _otherCompleted = boardSnapshot.data['반띵완료_참가자'] as bool;
                    }
                  } else {
                    _userIsHost = false;
                    _otherPhoneNumber = boardSnapshot.data['개설자핸드폰번호'];
                    _myNickname = boardSnapshot.data['참가자닉네임'];
                    _otherNickname = boardSnapshot.data['개설자닉네임'];
                    _myCompleted = boardSnapshot.data['반띵완료_참가자'] as bool;
                    _otherCompleted = boardSnapshot.data['반띵완료_개설자'] as bool;
                    _enteredTime =
                        ((boardSnapshot.data['참가자참여시간']) as Timestamp).toDate();
                  }
                  if (_myCompleted && _otherCompleted) {
                    // 둘다 반띵완료를 누른 경우
                    // boardPage.popUpDialog(context, "반띵이 완료되었어요!");
                    userSnapshot.data.reference.updateData({
                      '채팅중인방ID': '',
                      '이용횟수': int.parse(_myOrders) + 1,
                      'nickname': ''
                    });
                    List<dynamic> _users = [
                      _userPhoneNumber,
                      _otherPhoneNumber
                    ];
                    Firestore.instance
                        .collection('완료내역')
                        .document(_chattingRoomID)
                        .setData({
                      '식당이름': _restaurant,
                      '주문시간': _orderTime,
                      '만날장소': _meetingPlace,
                      '사용자': _users,
                      '위치': _userLocation
                    });
                    boardSnapshot.data.reference.delete();
                    return Container();
                  }
                  return Scaffold(
                    appBar: AppBar(
                      brightness: Brightness.light,
//                      leading: IconButton(
//                          icon: Icon(Icons.arrow_back),
//                          onPressed: () => Navigator.of(context)
//                              .pushReplacement(MaterialPageRoute(
//                              builder: (context) => Background_Page()))),
                      title: _otherPhoneNumber == ''
                          ? Text('참여중인 사람이 없어요 ㅜ.ㅜ', style: text_grey_15())
                          : (_myCompleted && !_otherCompleted)
                              ? Text(
                                  '상대방의 완료를 기다리고 있어요!',
                                  style: text_grey_15(),
                                )
                              : drawer_completeOrder(context),
                      backgroundColor: Colors.white10,
                      elevation: 0,
                      iconTheme: IconThemeData(color: Colors.black),
                    ),
                    endDrawer: drawerAll(context),
                    body: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection("board")
                                .document(_chattingRoomID)
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
                          Container(
                            height: 20,
                          )
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
                    controller: _textController,
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
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isWritting && _otherPhoneNumber != ''
                  ? Colors.pink
                  : Colors.grey,
            ),
            onPressed: _textController.text != ''
                ? () => onSendMessage(_textController.text, 0)
                : null,
          ),
        ],
      ),
    );
  }

  void onSendMessage(String text, int type) {
    // type: 0 = 일반 메세지, 1 = 공지 메세지
    if (text.isNotEmpty) {
      _textController.clear();
      var documentReference = chatReference
          .document(DateTime.now().millisecondsSinceEpoch.toString());
      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'text': text,
            'sender_phone': type == 1 ? '공지' : _userPhoneNumber,
            'sender_nickname': type == 1 ? '' : _myNickname,
            'time': DateTime.now(),
            'delivered': false,
          },
        );
        print("onSendMessage - transaction");
      });
    }
  }

  Widget noChattingRoom(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Column(
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
          Positioned(
            left: 20,
            top: 40,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerAll(BuildContext context) {
    String orderTimeStr = '';
    DateTime date = _orderTime.toDate();
    var now = DateTime.now();
    var diff = now.difference(date);
    if (diff.inDays > 0) {
      orderTimeStr = orderTimeStr + '내일';
    } else {
      orderTimeStr = orderTimeStr + '오늘';
    }
    if (date.hour > 12) {
      orderTimeStr = orderTimeStr + ' 오후';
    } else {
      orderTimeStr = orderTimeStr + ' 오전';
    }
    var format = DateFormat(' h:mm 주문예정');
    orderTimeStr = orderTimeStr + format.format(date);
    return Drawer(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text(
                _restaurant,
                style: text_grey_20(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text(
                orderTimeStr,
                style: text_grey_15(),
              ),
            ),
            ListTile(
              leading: Icon(Icons.place),
              title: Text(
                '만날 장소 : $_meetingPlace',
                style: text_grey_15(),
              ),
            ),
            _otherPhoneNumber == ''
                ? drawer_delete(context) // 참가자가 없을 경우 => 게시물 삭제
                : drawer_otherOrderCount(
                    // 참가자가 있을 경우 => 상대방의 반띵횟수 출력
                    context),
            _userIsHost &&
                    !_myCompleted &&
                    !_otherCompleted &&
                    _otherPhoneNumber != ''
                ? drawer_otherExit(
                    // 자신이 개설자이고 자신과 상대방 둘다 완료버튼을 누르지 않은 경우 => 상대방 내보내기 버튼 표시
                    context,
                  )
                : !_myCompleted && !_otherCompleted && _otherPhoneNumber != ''
                    ? drawer_userExit(
                        context,
                      ) // 자신이 참가자이고 자신과 상대방 둘다 완료버튼을 누르지 않은 경우 => 참가자 스스로 반띵 나가기 버튼
                    : Container()
          ]),
    );
  }

  Widget drawer_delete(BuildContext context) {
    // 개설자가 자신의 방 삭제
    return ListTile(
        leading: Icon(
          Icons.restaurant,
          color: Colors.grey,
        ),
        title: Text('게시물 삭제하기', style: text_grey_20()),
        onTap: () {
          // 게시물 삭제
          userSnapshot.data.reference
              .updateData({'채팅중인방ID': '', 'nickname': ''});
          boardSnapshot.data.reference.delete();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Background_Page()));
        });
  }

  Widget drawer_otherOrderCount(BuildContext context) {
    // 상대방의 주문횟수
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(_otherPhoneNumber)
            .snapshots(),
        builder: (context, otherUserSnapshot) {
          if (!otherUserSnapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          this.otherUserSnapshot = otherUserSnapshot;
          _otherOrders = otherUserSnapshot.data['이용횟수'].toString();
          return ListTile(
              leading: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              title: Text('${_otherNickname}님의 반띵 횟수 : ${_otherOrders}',
                  style: text_grey_15()));
        });
  }

  Widget drawer_completeOrder(BuildContext context) {
    // 주문 완료
    return Center(
        child: RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.restaurant,
            color: Colors.pink,
          ),
          SizedBox(width: 10),
          Text('반띵 완료하기', style: text_pink_20()),
        ],
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Survey_Page(
                  snapshot_board: boardSnapshot,
                  userIsHost: _userIsHost,
                )));
      },
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.pink)),
    ));
  }

  Widget drawer_userExit(BuildContext context) {
    // 참가자가 스스로 방을 나감
    return ListTile(
      leading: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
      title: Text('다른 반띵하기', style: text_grey_20()),
      onTap: () {
        userSnapshot.data.reference.updateData({'채팅중인방ID': '', 'nickname': ''});
        setState(() {
          onSendMessage('${_otherNickname}님이 반띵을 취소하였습니다.', 1);
        });
        boardSnapshot.data.reference.updateData({
          '참가자핸드폰번호': '',
          '참가자참여시간': '',
          '참가자닉네임': '',
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Background_Page()));
      },
    );
  }

  Widget drawer_otherExit(BuildContext context) {
    // 개설자가 참가자를 내보냄
    return ListTile(
      leading: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
      title: Text('참가자 내보내기', style: text_grey_20()),
      onTap: () {
        setState(() {
          // 참가자를 내보냈을 때 :
          // 참가자가 내가 보낸 채팅을 읽지 않았을 경우 delivered = true 로 변경 => 나중에 다른 참가자가 입장했을 때 읽지 않은 메시지 수를 정확하게 출력하기 위함.
          chatReference
              .where('sender_phone', isEqualTo: _userPhoneNumber)
              .where('delivered', isEqualTo: false)
              .getDocuments()
              .then((QuerySnapshot ds) {
            ds.documents.forEach((doc) {
              Firestore.instance.runTransaction((transaction) async {
                await transaction.update(doc.reference, {'delivered': true});
                print("참가자 내보냄 - 내 메세지 delivered 값 변경");
              });
            });

            blockList.add(_otherPhoneNumber);
            onSendMessage('${_otherNickname}님을 내보냈습니다.', 1);

            boardSnapshot.data.reference.updateData({
              '참가자핸드폰번호': '',
              '참가자참여시간': '',
              '참가자닉네임': '',
              '내보낸사용자': FieldValue.arrayUnion(blockList)
            });
            otherUserSnapshot.data.reference
                .updateData({'채팅중인방ID': '', 'nickname': ''});
          });
        });
        Navigator.pop(context);
      },
    );
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      //print('onMessage: $message');
      //Platform.isAndroid ? showNotification(message['notification']) : showNotification(message['aps']['alert']);
      //return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(_userPhoneNumber)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid
          ? 'com.halfofthing.halfofthing'
          : 'com.halfofthing.halfofthing',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }
}
