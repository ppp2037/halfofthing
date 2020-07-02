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

class _User_Create_pageState extends State<User_Create_page> with TickerProviderStateMixin{
  final GlobalKey<FormState> _restaurantFormKey =
      GlobalKey<FormState>();
  final TextEditingController _restaurantController =
      TextEditingController();
  final GlobalKey<FormState> _meetingPlaceFormKey =
      GlobalKey<FormState>();
  final TextEditingController _meetingPlaceController =
      TextEditingController();

  @override
  void dispose() {
    _restaurantController.dispose();
    _meetingPlaceController.dispose();
    _bounceInOutController.dispose();
    super.dispose();
  }

  String _restaurant;
  var _orderTime;
  String _meetingPlace;
  String _boardCreatTime;

  String _userPhoneNumber;
  String _userLocation;
  String _userSelectedCategory;

  bool _isItemSelected = true;

  AnimationController _bounceInOutController;
  Animation _bounceInOutAnimation;

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
    _bounceInOutController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _bounceInOutController.forward();
  }

  int _selectedCategoryNumber = 0;

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

  @override
  Widget build(BuildContext context) {
    _bounceInOutAnimation = CurvedAnimation(
        parent: _bounceInOutController, curve: Curves.fastOutSlowIn);
    _bounceInOutAnimation.addListener(() {
      setState(() {});
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(_userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return snapshot.data['chattingRoomId'] != ''
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
              : _isItemSelected
                  ? ListView(
                      children: <Widget>[
                        Container(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 1;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images1.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '간식/도시락',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 2;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images2.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '카페/디저트',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 3;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images3.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '분식',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 4;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images4.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '한식',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 5;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images5.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '햄버거',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 6;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images6.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '중국집',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 7;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images7.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '일식/돈까스',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _selectedCategoryNumber = 8;
                                _userSelectedCategory =
                                    _selectedCategory[_selectedCategoryNumber];
                                setState(() {
                                  _isItemSelected = !_isItemSelected;
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images8.png',
                                    width:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                    height:
                                    Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
                                  ),
                                  Container(
                                    height: 10,
                                  ),
                                  Text(
                                    '아시안/양식',
                                    style: text_darkgrey_15(),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'images/food_images' +
                                        _selectedCategoryNumber.toString() +
                                        '.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  Container(
                                    width: 10,
                                  ),
                                  Text(
                                    _userSelectedCategory,
                                    style: text_darkgrey_15(),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 15,
                              top: 15,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isItemSelected = !_isItemSelected;
                                  });
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, bottom: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            elevation: 15,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 5, bottom: 5),
                              child: Form(
                                key: _restaurantFormKey,
                                child: TextFormField(
                                  style: text_grey_15(),
                                  onChanged: (String str) {
                                    setState(() {
                                      _restaurant = str;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: _restaurantController,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.restaurant,
                                        color: Colors.grey[700],
                                      ),
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
                                borderRadius: BorderRadius.circular(60)),
                            elevation: 15,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 5, bottom: 5),
                              child: Form(
                                key: _meetingPlaceFormKey,
                                child: TextFormField(
                                  style: text_grey_15(),
                                  onChanged: (String str) {
                                    setState(() {
                                      _meetingPlace = str;
                                    });
                                  },
                                  keyboardType: TextInputType.text,
                                  controller: _meetingPlaceController,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.place,
                                        color: Colors.grey[700],
                                      ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.grey[700],
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                      Text(
                                        '받을 시간',
                                        style: text_darkgrey_15(),
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
                                      minutesInterval: 10,
                                      onTimeChange: (time) {
                                        setState(() {
                                          _orderTime = time;
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
                              var _userOrderId = DateFormat('yyyyMMddHHmmss')
                                  .format(_currentTime);
                              var _boardID =
                                  _userPhoneNumber + '_' + _userOrderId;
                              var now = DateTime.now();
                              // 현재 시각 - time 시각 >0 이면 다음날로 설정
                              if (now.hour > _orderTime.hour) {
                                _orderTime =
                                    _orderTime.add(new Duration(days: 1));
                              }
                              Firestore.instance
                                  .collection('board')
                                  .document(
                                      _userPhoneNumber + '_' + _userOrderId)
                                  .setData({
                                'restaurant': _restaurant,
                                'orderTime': Timestamp.fromDate(_orderTime),
                                'university': _userLocation,
                                'meetingPlace': _meetingPlace,
                                'hostId': _userPhoneNumber,
                                'guestId': '',
                                'boardName': _boardID,
                                'guestEnterTime': '',
                                'hostNickname': randomNickname(),
                                'guestNickname': '',
                                'createTime': DateTime.now(),
                                'hostComplete': false,
                                'guestComplete': false,
                                'blockList': [],
                                'menuCategory': _selectedCategoryNumber.toString(),
                              });
                              Firestore.instance
                                  .collection('users')
                                  .document(_userPhoneNumber)
                                  .updateData({'chattingRoomId': _boardID});
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
                                  borderRadius: BorderRadius.circular(60)),
                              elevation: 15,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
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
