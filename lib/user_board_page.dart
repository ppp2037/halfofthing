import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:halfofthing/settings/nickname_list.dart';
import 'package:halfofthing/user_history_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'settings/styles.dart';
import 'user_chat_page.dart';
import 'user_settings_feedback_page.dart';
import 'user_settings_help_page.dart';
import 'user_settings_howto_page.dart';
import 'user_settings_notice_page.dart';
import 'package:intl/intl.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:firebase_database/firebase_database.dart';


class User_Board_Page extends StatefulWidget {
  @override
  _User_Board_PageState createState() => _User_Board_PageState();
}

class _User_Board_PageState extends State<User_Board_Page>
    with TickerProviderStateMixin {
  String _userPhoneNumber;
  String _userLocation;
  bool _isNotificationChecked = false;
  bool _userIsChatting = false; // 사용자가 기존에 참여하고 있는 채팅방이 있는지
  DateTime currentTime;

  List<String> _selectedCategory = [
    '미선택',
    '간식/도시락',
    '카페/디저트',
    '분식',
    '한식',
    '햄버거',
    '중국집',
    '일식/돈까스',
    '아시안/양식'
  ];

  AnimationController _bounceInOutController;
  Animation _bounceInOutAnimation;

//  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
//  String _bannerImageURL = '';
//  StorageReference storageReference =
//  _firebaseStorage.ref().child('banner/');
  DatabaseReference fbRef;

  @override
  void initState() {
    super.initState();
    currentTime = DateTime.now();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        _userLocation = prefs.getString('prefsLocation');
      });
      fbRef = FirebaseDatabase.instance.reference().child("chatting");

    })();
    _bounceInOutController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _bounceInOutController.forward();
  }

  @override
  void dispose() {
    _bounceInOutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bounceInOutAnimation = CurvedAnimation(
        parent: _bounceInOutController, curve: Curves.bounceInOut);
    _bounceInOutAnimation.addListener(() {
      setState(() {});
    });
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(_userPhoneNumber)
              .snapshots(),
          builder: (context, snapshot_user) {
            if (!snapshot_user.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot_user.data['chattingRoomId'] != '') {
              _userIsChatting = true;
            }else{
              _userIsChatting = false;
            }
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                iconTheme: IconThemeData(color: Colors.grey[700]),
                backgroundColor: Colors.white,
                brightness: Brightness.light,
                elevation: 0,
                centerTitle: true,
                title: Text('반띵', style: text_pink_25()),
                leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Settings_Howto_Page()));
                    },
                    child: Icon(Icons.help_outline)),
              ),
              endDrawer: Drawer(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        snapshot_user.data['userName'],
                        style: text_darkgrey_20(),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        snapshot_user.data['university'],
                        style: text_darkgrey_20(),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.apps,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '이용횟수  :  ' + snapshot_user.data['orderNum'].toString(),
                        style: text_darkgrey_15(),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.history,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '주문내역',
                        style: text_darkgrey_15(),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => User_History_Page()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '공지사항',
                        style: text_darkgrey_15(),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => User_Settings_Notice_page()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.edit,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '개선사항',
                        style: text_darkgrey_15(),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                User_Settings_Feedback_Page()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.help_outline,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '고객지원',
                        style: text_darkgrey_15(),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => User_Settings_Help_Page()));
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.notifications_active,
                        color: Colors.grey[700],
                      ),
                      title: Row(
                        children: <Widget>[
                          Text(
                            '푸시알림',
                            style: text_darkgrey_15(),
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
                      leading: Icon(
                        Icons.lock,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '개인정보 처리방침',
                        style: text_darkgrey_15(),
                      ),
                      onTap: () {
                        launchUrl();
                      },
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.clear,
                        color: Colors.grey[700],
                      ),
                      title: Text(
                        '로그아웃',
                        style: text_darkgrey_15(),
                      ),
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
                                    Text('로그아웃 하시겠어요?', style: text_pink_20()),
                                    Container(
                                      height: 30,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60)),
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Center(
                                                child: Text('취소',
                                                    style: text_darkgrey_15()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            (() async {
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                prefs.clear();
                                              });
                                            })();
                                            Phoenix.rebirth(context);
                                          },
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(60)),
                                            elevation: 5,
                                            color: Colors.white,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                  top: 15,
                                                  bottom: 15),
                                              child: Center(
                                                child: Text('확인',
                                                    style: text_darkgrey_15()),
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
                    ),
                    ListTile(
                      title: Column(
                        children: <Widget>[
                          Container(
                            height: 20,
                          ),
                          Text(
                            'Copyright © 2020 NomadCAT Inc.',
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
              body: ListView(
                children: <Widget>[
                  StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('banner')
                          .document('banner')
                          .snapshots(),
                      builder: (context, bannerSnapshot) {
                        if (!bannerSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                            height: 150,
                            child: Carousel(
                              images: [
                                Stack(children: <Widget>[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Center(
                                      child: Image.network(
                                          bannerSnapshot.data['url1']))
                                ]),
                                Stack(children: <Widget>[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Center(
                                      child: Image.network(
                                          bannerSnapshot.data['url2']))
                                ]),
                                Stack(children: <Widget>[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  Center(
                                      child: Image.network(
                                          bannerSnapshot.data['url3']))
                                ]),
                              ],
                              dotSize: 4,
                              dotSpacing: 15,
                              dotColor: Colors.brown,
                              dotIncreaseSize: 3,
                              indicatorBgPadding: 5.0,
                              dotBgColor: Colors.grey.withOpacity(0.0),
                              borderRadius: false,
                            ));
                      }),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('board')
                        .where('university', isEqualTo: _userLocation)
                        .snapshots(),
                    builder: (context, boardSnapshot) {
                      if (!boardSnapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if (boardSnapshot.data.documents.isEmpty)
                        return Column(
                          children: <Widget>[
                            Container(
                              height: 40,
                            ),
                            Text('반띵중인 사람이 없어요', style: text_grey_15()),
                            Container(
                              height: 15,
                            ),
                            Text('가운데 시작을 눌러 반띵을 시작해보세요',
                                style: text_grey_15()),
                            Container(
                              height: 40,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('history')
                                    .where('university',
                                        isEqualTo: _userLocation)
                                    .snapshots(),
                                builder: (context, completedSnapshot) {
                                  if (!completedSnapshot.hasData) {
                                    return _buildList(
                                        context,
                                        boardSnapshot.data.documents,
                                        _userPhoneNumber,
                                        null);
                                  }
                                  return _buildList(
                                      context,
                                      boardSnapshot.data.documents,
                                      _userPhoneNumber,
                                      completedSnapshot.data.documents);
                                }),
                          ],
                        );
                      return StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('history')
                              .where('university', isEqualTo: _userLocation)
                              .snapshots(),
                          builder: (context, completedSnapshot) {
                            if (!completedSnapshot.hasData) {
                              return _buildList(
                                  context,
                                  boardSnapshot.data.documents,
                                  _userPhoneNumber,
                                  null);
                            }
                            return _buildList(
                                context,
                                boardSnapshot.data.documents,
                                _userPhoneNumber,
                                completedSnapshot.data.documents);
                          });
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> boardSnapshot,
      _userPhoneNumber, List<DocumentSnapshot> completedSnapshot) {
    boardSnapshot.sort((a, b) => Record.fromSnapshot(a)
        .orderTime
        .compareTo(Record.fromSnapshot(b).orderTime));
    var itemList = boardSnapshot.map((data) {
      // if (_userPhoneNumber != data.data['개설자핸드폰번호'])
      return _buildListItem(context, data, _userPhoneNumber);
    }).toList();
    if (completedSnapshot != null) {
      var completedItemList = completedSnapshot
          .map((data) => _buildCompletedListItem(context, data))
          .toList();
      itemList.addAll(completedItemList);
    }
    return Column(
      children: itemList,
    );
  }

  Widget _buildCompletedListItem(
      BuildContext context, DocumentSnapshot completedData) {
    DateTime orderDate =
        ((completedData.data['orderTime']) as Timestamp).toDate();
    String completedDate = DateFormat('MM월 dd일').format(orderDate);
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(seconds: 2), () {
                Navigator.pop(context);
              });
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: FittedBox(
                  fit: BoxFit.contain,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                        child: Text(
                      '이미 반띵이 완료된 게시물이에요',
                      style: text_darkgrey_20(),
                    )),
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset(
                            'images/food_images' +
                                completedData.data['menuCategory'] +
                                '.png',
                            width: Tween(begin: 0.0, end: 60.0)
                                .evaluate(_bounceInOutAnimation),
                            height: Tween(begin: 0.0, end: 60.0)
                                .evaluate(_bounceInOutAnimation),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            _selectedCategory[
                                int.parse(completedData.data['menuCategory'])],
                            style: text_grey_10(),
                          ),
                        ],
                      ),
                      Container(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.restaurant,
                                color: Colors.grey,
                              ),
                              Container(width: 10),
                              Text(
                                completedData.data['restaurant'],
                                style: text_grey_20(),
                              ),
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.grey,
                              ),
                              Container(width: 10),
                              Text(completedData.data['meetingPlace'],
                                  style: text_grey_15())
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  Container(width: 10),
                                  Text(completedDate, style: text_grey_15())
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 75),
                    child: Text(
                      '반띵완료',
                      style: text_pink_15(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data_board,
      String _userPhoneNumber) {
    final record = Record.fromSnapshot(data_board);
    DateTime orderDate = ((record.orderTime) as Timestamp).toDate();
    var diff = orderDate.difference(currentTime);
    var orderTime = '';

    if (diff.inDays > 0) {
      orderTime = orderTime + '내일';
    } else {
      orderTime = orderTime + '오늘';
    }
    if (orderDate.hour > 12) {
      orderTime = orderTime + ' 오후';
    } else {
      orderTime = orderTime + ' 오전';
    }
    var format = DateFormat(' h:mm 주문예정');
    orderTime = orderTime + format.format(orderDate);
    var _myRoom = false;
    if (_userPhoneNumber == record.phoneNumber ||
        _userPhoneNumber == record.phoneNumber2) _myRoom = true;

    return GestureDetector(
      onTap: () {
        if (_myRoom) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => User_Chat_Page()));
        } else if (_userIsChatting) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        '현재 진행중인 반띵이 있기 때문에\n입장하실 수 없어요',
                        style: text_darkgrey_20(),
                      )),
                    ),
                  ),
                );
              });
        } else if (record.phoneNumber2 != '') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        '이미 반띵중인 게시물이에요',
                        style: text_darkgrey_20(),
                      )),
                    ),
                  ),
                );
              });
        } else if (record.blockedList.contains(_userPhoneNumber)) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(Duration(seconds: 2), () {
                  Navigator.pop(context);
                });
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                          child: Text(
                        '들어갈 수 없는 게시물이에요ㅜ.ㅜ',
                        style: text_darkgrey_20(),
                      )),
                    ),
                  ),
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text('반띵을 시작하시겠어요?', style: text_pink_20()),
                      Container(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.restaurant,
                            color: Colors.grey[700],
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(record.restaurant, style: text_darkgrey_20()),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Colors.grey[700],
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(record.meetingPlace, style: text_darkgrey_20()),
                        ],
                      ),
                      Container(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[700],
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(orderTime, style: text_darkgrey_20()),
                        ],
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
                                  borderRadius: BorderRadius.circular(60)),
                              elevation: 5,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 15, bottom: 15),
                                child: Center(
                                  child: Text('취소', style: text_darkgrey_15()),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // 게시물에 새로 참가하기
                              String nickName = randomNickname();
                              data_board.reference.updateData({
                                'guestId': _userPhoneNumber,
                                'guestEnterTime': DateTime.now(),
                                'guestNickname': nickName,
                              });
                              fbRef
                                  .child(record.boardname)
                                  .child(DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString())
                                  .set({
                                'text': "${nickName}님이 입장하셨습니다.",
                                'sender_phone': "공지",
                                'sender_nickname': "",
                                'time': DateTime.now().millisecondsSinceEpoch,
                                'delivered': false,
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(_userPhoneNumber)
                                  .updateData({
                                'chattingRoomId': record.boardname,
                                'nickname': nickName,
                              });
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => User_Chat_Page()));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60)),
                              elevation: 5,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, right: 25, top: 15, bottom: 15),
                                child: Center(
                                  child: Text('확인', style: text_darkgrey_15()),
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
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 15,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Image.asset(
                            'images/food_images' + record.menuCategory + '.png',
                            width: Tween(begin: 0.0, end: 60.0)
                                .evaluate(_bounceInOutAnimation),
                            height: Tween(begin: 0.0, end: 60.0)
                                .evaluate(_bounceInOutAnimation),
                          ),
                          Container(
                            height: 10,
                          ),
                          Text(
                            _selectedCategory[int.parse(record.menuCategory)],
                            style: text_grey_10(),
                          ),
                        ],
                      ),
                      Container(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.restaurant,
                                color: Colors.grey[700],
                              ),
                              Container(width: 10),
                              Text(
                                record.restaurant,
                                style: text_darkgrey_20(),
                              ),
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.place,
                                color: Colors.grey[700],
                              ),
                              Container(width: 10),
                              Text(record.meetingPlace,
                                  style: text_darkgrey_15())
                            ],
                          ),
                          Container(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey[700],
                                  ),
                                  Container(width: 10),
                                  Text(orderTime, style: text_darkgrey_15())
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return editOrderInfo(context, record.restaurant,
                                record.meetingPlace, data_board);
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 75),
                      child: _userPhoneNumber == record.phoneNumber
                          ? Row(
                              children: [
                                Text(
                                  'my 주문',
                                  style: text_pink_15(),
                                ),
                                Container(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.edit,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                              ],
                            )
                          : _userPhoneNumber == record.phoneNumber2
                              ? Text(
                                  '내가 참여중',
                                  style: text_pink_15(),
                                )
                              : record.phoneNumber2 != ''
                                  // 참가자핸드폰번호에 누군가 있으면 반띵중 문구 표시
                                  ? Text(
                                      '반띵중',
                                      style: text_green_15_bold(),
                                    )
                                  : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget editOrderInfo(BuildContext context, var restaurant, var meetingPlace,
      DocumentSnapshot boardSnapshot) {
    var _editMeetingPlace, _editOrderTime;
    print("editOrder");
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('주문 정보 변경하기', style: text_pink_20()),
          Container(
            height: 20,
          ),
          Row(
            children: [
              Icon(
                Icons.restaurant,
                color: Colors.grey[700],
              ),
              Container(
                width: 15,
              ),
              Text(restaurant, style: text_darkgrey_15()),
            ],
          ),
          Container(
            height: 20,
          ),
          Form(
            child: TextFormField(
              onChanged: (String str) {
                setState(() {
                  _editMeetingPlace = str;
                });
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                icon: Icon(
                  Icons.place,
                  color: Colors.pink,
                ),
                hintText: meetingPlace,
                hintStyle: text_grey_15(),
              ),
            ),
          ),
          Container(
            height: 20,
          ),
          Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: Colors.pink,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    '받을 시간',
                    style: text_pink_15(),
                  ),
                ],
              ),
              Flexible(
                child: TimePickerSpinner(
                  is24HourMode: true,
                  normalTextStyle: text_grey_15(),
                  highlightedTextStyle: text_pink_15(),
                  spacing: 10,
                  itemHeight: 40,
                  itemWidth: 40,
                  isForce2Digits: true,
                  minutesInterval: 10,
                  onTimeChange: (time) {
                    setState(() {
                      _editOrderTime = time;
                    });
                  },
                ),
              ),
            ],
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
                      borderRadius: BorderRadius.circular(60)),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 15),
                    child: Center(
                      child: Text('취소', style: text_darkgrey_15()),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_editMeetingPlace == null)
                    _editMeetingPlace = meetingPlace;
                  boardSnapshot.reference.updateData({
                    'meetingPlace': _editMeetingPlace,
                    'orderTime': Timestamp.fromDate(_editOrderTime)
                  });
                  Navigator.of(context).pop();
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60)),
                  elevation: 5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 15, bottom: 15),
                    child: Center(
                      child: Text('수정', style: text_darkgrey_15()),
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
}

class Record {
  final String phoneNumber, phoneNumber2;
  final String restaurant, location, boardname, meetingPlace, menuCategory;
  var orderTime, enteredTime, createdTime;
  final DocumentReference reference;
  final List<dynamic> blockedList;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['hostId'] != null),
        assert(map['guestId'] != null),
        assert(map['restaurant'] != null),
        assert(map['orderTime'] != null),
        assert(map['university'] != null),
        assert(map['meetingPlace'] != null),
        assert(map['boardName'] != null),
        assert(map['createTime'] != null),
        assert(map['menuCategory'] != null),
        phoneNumber = map['hostId'],
        phoneNumber2 = map['guestId'],
        restaurant = map['restaurant'],
        orderTime = map['orderTime'],
        location = map['university'],
        meetingPlace = map['meetingPlace'],
        boardname = map['boardName'],
        enteredTime = map['guestEnterTime'],
        createdTime = map['createTime'],
        blockedList = map['blockList'],
        menuCategory = map['menuCategory'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$phoneNumber:$phoneNumber2:$restaurant:$orderTime:$location:$meetingPlace:$boardname:$menuCategory>";
}

launchUrl() async {
  const url =
      'https://www.facebook.com/permalink.php?story_fbid=115352936899114&id=115341866900221&__tn__=-R';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw '인터넷 연결이 원활하지 않습니다';
  }
}
