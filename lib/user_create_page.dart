import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_page.dart';
import 'settings/styles.dart';
import 'package:halfofthing/settings/nickname_list.dart';

class User_Create_page extends StatefulWidget {
  @override
  _User_Create_pageState createState() => _User_Create_pageState();
}

class _User_Create_pageState extends State<User_Create_page> {
  final GlobalKey<FormState> _restaurantFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _restaurantController =
      TextEditingController(); //컨트롤러 생성
  final GlobalKey<FormState> _meetingPlaceFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _meetingPlaceController =
      TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _restaurantController.dispose();
    _meetingPlaceController.dispose();
    super.dispose();
  }

  String _restaurant;
  var _time;
  String _meetingPlace;
  String _boardCreatTime;

  String _userPhoneNumber;
  String _userLocation;

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

//  int _selectedMenuNumber = 0;

//  List<String> _selectedMenu = ['미선택', '한식', '중식', '일식', '분식', '음료', '패스트푸드'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('사용자')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return snapshot.data['채팅중인방ID'] != ''
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '지금 진행중인 반띵이 있어요',
                      style: text_grey_15(),
                    ),
                    Container(
                      height: 60,
                    ),
                    Text(
                      '새로운 반띵을 시작하려면',
                      style: text_grey_15(),
                    ),
                    Container(
                      height: 20,
                    ),
                    Text(
                      '기존 반띵을 취소해주세요',
                      style: text_grey_15(),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          '반띵할 사람이 생기면 알림으로 알려드려요',
                          style: text_grey_15(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          child: Form(
                            key: _restaurantFormKey,
                            child: TextFormField(
                              onChanged: (String str) {
                                setState(() {
                                  _restaurant = str;
                                });
                              },
                              keyboardType: TextInputType.text,
                              controller: _restaurantController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.restaurant),
                                  hintText: '식당 이름',
                                  border: InputBorder.none),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return '식당 이름을 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          child: Form(
                            key: _meetingPlaceFormKey,
                            child: TextFormField(
                              onChanged: (String str) {
                                setState(() {
                                  _meetingPlace = str;
                                });
                              },
                              keyboardType: TextInputType.text,
                              controller: _meetingPlaceController,
                              decoration: InputDecoration(
                                  icon: Icon(Icons.place),
                                  hintText: '만날 장소',
                                  border: InputBorder.none),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return '만날 장소를 입력해주세요';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    '받을 시간',
                                    style: text_grey_15(),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: TimePickerSpinner(
                                  is24HourMode: true,
                                  normalTextStyle: text_grey_15(),
                                  highlightedTextStyle: text_pink_20(),
                                  spacing: 20,
                                  itemHeight: 50,
                                  itemWidth: 40,
                                  isForce2Digits: true,
                                  onTimeChange: (time) {
                                    setState(() {
                                      _time = DateFormat('yyyyMMddHHmmss')
                                          .format(time);
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_restaurantFormKey.currentState.validate()) {
                          var _currentTime = DateTime.now();
                          var _userOrderId =
                              DateFormat('yyyyMMddHHmmss').format(_currentTime);
                          var _boardID = _userPhoneNumber + '_' + _userOrderId;
                          Firestore.instance
                              .collection('게시판')
                              .document(_userPhoneNumber + '_' + _userOrderId)
                              .setData({
                            '식당이름': _restaurant,
                            '주문시간': _time,
                            '위치': _userLocation,
                            '만날장소': _meetingPlace,
                            '개설자핸드폰번호': _userPhoneNumber,
                            '참가자핸드폰번호': '',
                            '게시판이름': _boardID,
                            '참가자참여시간': '',
                            '개설자닉네임': randomNickname(),
                            '참가자닉네임': '',
                            '생성시간': DateTime.now().toString(),
                            '반띵완료_개설자': false,
                            '반띵완료_참가자': false
                          });
                          Firestore.instance
                              .collection('사용자')
                              .document(_userPhoneNumber)
                              .updateData({'채팅중인방ID': _boardID});

                          Fluttertoast.showToast(
                              msg: '새로운 반띵이 등록되었어요',
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.pink,
                              textColor: Colors.white);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Background_Page()));
                        } else {}
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: Card(
                          color: Colors.pink,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 15,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, bottom: 5),
                            child: Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                  '반띵하기',
                                  style: text_white_20(),
                                ))),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
