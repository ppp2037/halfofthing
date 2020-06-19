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
  @override
  _User_Chat_PageState createState() => _User_Chat_PageState();
}

class _User_Chat_PageState extends State<User_Chat_Page> {
  CollectionReference chatReference;
  final TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  String _userPhoneNumber,
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
      Column(
        children: <Widget>[
          Text(documentSnapshot.data['sender_nickname'],
              style: text_white_15()),
          Container(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              timeStampText(documentSnapshot),
              deliveredIcon(documentSnapshot),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.pink,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Center(
                    child: Text(
                      documentSnapshot.data['text'],
                      style: text_white_15(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      )
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    // 상대방의 말풍선
    documentSnapshot.reference.updateData({'delivered': true});
    return <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(documentSnapshot.data['sender_nickname'],
              style: text_white_15()),
          Container(
            height: 5,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Center(
                  child: Text(
                    documentSnapshot.data['text'],
                    style: text_black_15(),
                  ),
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
    print(
        "build => chattingRoom : $_chattingRoomID, userIsHost : $_userIsHost, userphone : $_userPhoneNumber, otherPhone : $_otherPhoneNumber");
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
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
                    .collection('게시판')
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
                    userSnapshot.data.reference.updateData(
                        {'채팅중인방ID': '', '이용횟수': int.parse(_myOrders) + 1});
                    return Container();
                  }
                  return Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Background_Page()))),
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
              child: _userIsHost && _otherPhoneNumber == null
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
    print('send start');
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

  Widget noChattingRoom(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Background_Page()))),
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
  }

  Widget drawerAll(BuildContext context) {
    var format = DateFormat('MM월 dd일 HH:mm 주문예정');
    DateTime date = _orderTime.toDate();
    String orderTimeStr = format.format(date).toString();
    return Drawer(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('주문할 음식점 : $_restaurant', style: text_grey_20()),
            Text('$orderTimeStr', style: text_grey_20()),
            Text('만날 장소 : $_meetingPlace', style: text_grey_20()),
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
          userSnapshot.data.reference.updateData({'채팅중인방ID': ''});
          boardSnapshot.data.reference.delete();
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Background_Page()));
        });
  }

  Widget drawer_otherOrderCount(BuildContext context) {
    // 상대방의 주문횟수
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
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
                  style: text_grey_20()));
        });
  }

  Widget drawer_completeOrder(BuildContext context) {
    // 주문 완료
    return Center(
        child: RaisedButton(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
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
        userSnapshot.data.reference.updateData({'채팅중인방ID': ''});
        chatReference.add({
          'text': '${_otherNickname}님이 반띵을 취소하였습니다.',
          'sender_phone': '공지',
          'sender_nickname': "",
          'time': DateTime.now(),
          'delivered': true,
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
        otherUserSnapshot.data.reference.updateData({'채팅중인방ID': ''});
        blockList.add(_otherPhoneNumber);
        boardSnapshot.data.reference.updateData({
          '참가자핸드폰번호': '',
          '참가자참여시간': '',
          '참가자닉네임': '',
          '내보낸사용자': FieldValue.arrayUnion(blockList)
        });

        chatReference.add({
          'text': '${_otherNickname}님을 내보냈습니다.',
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
