import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:halfofthing/user_board_page.dart' as boardPage;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'background_page.dart';
import 'settings/styles.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
  String _userPhoneNumber, _otherPhoneNumber, _myNickname, _otherNickname;
  String _chattingRoomID;
  bool _userIsHost = true; // 사용자가 채팅방 개설자인지
  bool _myCompleted, _otherCompleted; // 나와 상대방의 반띵완료 클릭 여부 저장
  String _otherOrderCount;
  var _enteredTime;
  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        // print("UserPhone : $_userPhoneNumber");
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
                  if (snapshot_board.data['참가자핸드폰번호'] == '') {
                    // 참가자가 없을 경우
                    return Scaffold(
                      appBar: AppBar(
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => Background_Page()))),
                        title: Text(
                          '참여중인 사람이 없어요 ㅜ.ㅜ',
                          style: text_grey_15(),
                        ),
                        // automaticallyImplyLeading: false,
                        backgroundColor: Colors.white10,
                        elevation: 0,
                        iconTheme: IconThemeData(color: Colors.black),
                      ),
                      endDrawer: Drawer(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            drawer_delete(
                                context, snapshot_board, snapshot_user)
                          ])),
                      body: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Expanded(child: Container()),
                            Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.white,
                                child: _buildTextComposer()),
                          ],
                        ),
                      ),
                    );
                  }
                  // 채팅중인 상대방이 있을 경우
                  chatReference =
                      snapshot_board.data.reference.collection("messages");
                  // 사용자가 채팅방의 개설자인지 참여자인지 구분, 자신과 상대방 정보 저장
                  if (snapshot_board.data['개설자핸드폰번호'] == _userPhoneNumber) {
                    _otherPhoneNumber = snapshot_board.data['참가자핸드폰번호'];
                    _myNickname = snapshot_board.data['개설자닉네임'];
                    _otherNickname = snapshot_board.data['참가자닉네임'];
                    _myCompleted = snapshot_board.data['반띵완료_개설자'] as bool;
                    _otherCompleted = snapshot_board.data['반띵완료_참가자'] as bool;
                  } else {
                    _userIsHost = false;
                    _otherPhoneNumber = snapshot_board.data['개설자핸드폰번호'];
                    _myNickname = snapshot_board.data['참가자닉네임'];
                    _otherNickname = snapshot_board.data['개설자닉네임'];
                    _myCompleted = snapshot_board.data['반띵완료_참가자'] as bool;
                    _otherCompleted = snapshot_board.data['반띵완료_개설자'] as bool;
                  }
                  _enteredTime = DateTime.parse(snapshot_board.data['참가자참여시간']);
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('사용자')
                          .document(_otherPhoneNumber)
                          .snapshots(),
                      builder: (context, snapshot_other_user) {
                        if (!snapshot_other_user.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (_myCompleted && _otherCompleted) {
                          // 둘다 반띵완료를 누른 경우
                          // boardPage.popUpDialog(context, "반띵이 완료되었어요!");
                          snapshot_user.data.reference
                              .updateData({'채팅중인방ID': ''});
                          snapshot_other_user.data.reference
                              .updateData({'채팅중인방ID': ''});
                          return Container();
                        }
                        return Scaffold(
                          appBar: AppBar(
                            leading: IconButton(
                                icon: Icon(Icons.arrow_back),
                                onPressed: () => Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                            Background_Page()))),
                            title: Text(
                              !(_myCompleted || _otherCompleted)
                                  ? '반띵을 완료하면 우측상단 완료를 눌러주세요'
                                  : _myCompleted
                                      ? '상대방의 완료를 기다리고 있어요!'
                                      : '상대방이 반띵을 완료하였어요!',
                              style: text_grey_15(),
                            ),
                            backgroundColor: Colors.white10,
                            elevation: 0,
                            iconTheme: IconThemeData(color: Colors.black),
                          ),
                          endDrawer: Drawer(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _userIsHost
                                    ? _myCompleted // 자신이 개설자이고 완료버튼을 누른 경우
                                        ? <Widget>[
                                            drawer_otherOrderCount(
                                                // 상대방의 반띵횟수 출력
                                                context,
                                                snapshot_other_user)
                                          ]
                                        : <Widget>[
                                            drawer_otherOrderCount(
                                                // 상대방의 반띵횟수 출력
                                                context,
                                                snapshot_other_user),
                                            Container(
                                              height: 40,
                                            ),
                                            drawer_completeOrder(
                                                // 완료하기 버튼 표시
                                                context,
                                                snapshot_board,
                                                snapshot_user),
                                            Container(
                                              height: 40,
                                            ),
                                            drawer_otherExit(
                                                // 상대방 내보내기 버튼 표시
                                                context,
                                                snapshot_board,
                                                snapshot_other_user),
                                          ]
                                    : _myCompleted // 자신이 참가자이고 완료버튼을 누른 경우
                                        ? <Widget>[
                                            drawer_otherOrderCount(
                                                // 상대방의 반띵횟수 출력
                                                context,
                                                snapshot_other_user)
                                          ]
                                        : <Widget>[
                                            drawer_otherOrderCount(
                                                // 상대방의 반띵횟수 출력
                                                context,
                                                snapshot_other_user),
                                            Container(
                                              height: 40,
                                            ),
                                            drawer_completeOrder(context,
                                                snapshot_board, snapshot_user),
                                            Container(
                                              height: 40,
                                            ),
                                            drawer_userExit(
                                                context,
                                                snapshot_board,
                                                snapshot_user) // 참가자 스스로 반띵 나가기 버튼
                                          ]),
                          ),
                          body: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("게시판")
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
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.white,
                                    child: _buildTextComposer()),
                              ],
                            ),
                          ),
                        );
                      });
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
        'sender_nickname': _myNickname,
        'time': DateTime.now(),
        'delivered': false,
      }).then((documentReference) {
        setState(() {
          _isWritting = false;
        });
      }).catchError((e) {});
    }
  }

  Widget drawer_delete(BuildContext context, AsyncSnapshot snapshot_board,
      AsyncSnapshot snapshot_user) {
    // 개설자가 자신의 방 삭제
    return ListTile(
        leading: Icon(
          Icons.restaurant,
          color: Colors.grey,
        ),
        title: Text('게시물 삭제하기', style: text_grey_20()),
        onTap: () {
          // 게시물 삭제
          snapshot_user.data.reference.updateData({'채팅중인방ID': ''});
          snapshot_board.data.reference.delete();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Background_Page()));
        });
  }

  Widget drawer_otherOrderCount(
      BuildContext context, AsyncSnapshot snapshot_other_user) {
    // 상대방의 주문횟수
    return ListTile(
        leading: Icon(
          Icons.account_circle,
          color: Colors.grey,
        ),
        title: Text(
            '${_otherNickname} 님의 반띵 횟수 : ' +
                snapshot_other_user.data['이용횟수'].toString(),
            style: text_grey_20()));
  }

  Widget drawer_completeOrder(BuildContext context,
      AsyncSnapshot snapshot_board, AsyncSnapshot snapshot_user) {
    // 주문 완료
    return ListTile(
      leading: Icon(
        Icons.restaurant,
        color: Colors.grey,
      ),
      title: Text('반띵 완료하기', style: text_grey_20()),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Survey_Page(
                  snapshot_board: snapshot_board,
                  userIsHost: _userIsHost,
                )));
      },
    );
  }

  Widget drawer_userExit(BuildContext context, AsyncSnapshot snapshot_board,
      AsyncSnapshot snapshot_user) {
    // 참가자가 스스로 방을 나감
    return ListTile(
      leading: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
      title: Text('다른 반띵하기', style: text_grey_20()),
      onTap: () {
        snapshot_user.data.reference.updateData({'채팅중인방ID': ''});
        chatReference.add({
          'text': '${_otherNickname} 님이 반띵을 취소하였습니다.',
          'sender_phone': '공지',
          'sender_nickname': "",
          'time': DateTime.now(),
          'delivered': true,
        });
        snapshot_board.data.reference.updateData({
          '참가자핸드폰번호': '',
          '참가자참여시간': '',
          '참가자닉네임': '',
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Background_Page()));
      },
    );
  }

  Widget drawer_otherExit(BuildContext context, AsyncSnapshot snapshot_board,
      AsyncSnapshot snapshot_other_user) {
    // 개설자가 참가자를 내보냄
    return ListTile(
      leading: Icon(
        Icons.clear,
        color: Colors.grey,
      ),
      title: Text('참가자 내보내기', style: text_grey_20()),
      onTap: () {
        snapshot_other_user.data.reference.updateData({'채팅중인방ID': ''});

        List<dynamic> blockList = List.from(snapshot_board.data['내보낸사용자']);
        blockList.add(_otherPhoneNumber);
        snapshot_board.data.reference.updateData({
          '참가자핸드폰번호': '',
          '참가자참여시간': '',
          '참가자닉네임': '',
          '내보낸사용자': FieldValue.arrayUnion(blockList)
        });

        chatReference.add({
          'text': '${_otherNickname} 님을 내보냈습니다.',
          'sender_phone': '공지',
          'sender_nickname': "",
          'time': DateTime.now(),
          'delivered': true,
        });
        // 참가자를 내보냈을 때 :
        // 참가자가 내가 보낸 채팅을 읽지 않았을 경우 delivered = true 로 변경 => 나중에 다른 참가자가 입장했을 때 읽지 않은 메시지 수를 정확하게 출력하기 위함.
        chatReference
            .where('delivered', isEqualTo: false)
            .getDocuments()
            .then((QuerySnapshot ds) {
          print("delivered 값 변경");
          ds.documents
              .forEach((doc) => doc.reference.updateData({'delivered': true}));
        });
        Navigator.pop(context);
      },
    );
  }
}
