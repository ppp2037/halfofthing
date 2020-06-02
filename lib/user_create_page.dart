import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'settings/styles.dart';
import 'user_chat_page.dart';

class User_Create_page extends StatefulWidget {
  @override
  _User_Create_pageState createState() => _User_Create_pageState();
}

class _User_Create_pageState extends State<User_Create_page> {
  GoogleMapController _googleMapController;
  Position position;

  int _selectedMenuNumber = 0;

  //0:미선택, 1:지금 받기, 2:5분뒤 받기

  List<String> _selectedMenu = ['미선택', '한식', '중식', '일식', '분식', '음료', '패스트푸드'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                '가장 가까운 거리의 만남 장소로 반띵이 설정돼요',
                style: text_grey_15(),
              ),
              Container(
                height: 10,
              ),
              Text(
                '반띵할 사람이 생기면 알림으로 알려드려요',
                style: text_grey_15(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[1],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[2],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[3],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[4],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[5],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                  Container(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                            child: Text(
                          _selectedMenu[6],
                          style: text_black_20(),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget Chatstart(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '메뉴 :',
                    style: TextStyle(color: Colors.brown),
                    textScaleFactor: 1,
                  ),
                  Container(
                    width: 10,
                  ),
                ],
              ),
              Container(
                height: 40,
              ),
              Text(
                '반띵을 시작하시겠습니까?',
                style: TextStyle(color: Colors.brown),
                textScaleFactor: 1,
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
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
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
