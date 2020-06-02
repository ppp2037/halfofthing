import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';

import 'user_chat_page.dart';
import 'user_map_page.dart';

class Select_Page extends StatefulWidget {
  @override
  _Select_PageState createState() => _Select_PageState();
}

class _Select_PageState extends State<Select_Page> {
  int _selectedMenuNumber = 0;

  //0:미선택, 1:지금 받기, 2:5분뒤 받기

  List<String> _selectedMenu = ['미선택', '한식', '중식', '일식', '분식', '음료', '패스트푸드'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('반띵할 메뉴를 골라주세요'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('가장 가까운 거리의 만남 장소로 반띵이 설정돼요',style: text_grey_15(),),
              Container(
                height: 10,
              ),
              Text('반띵할 사람이 생기면 알림으로 알려드려요', style: text_grey_15(),)
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
