import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';

import 'add_account_page.dart';
import 'find_password_page.dart';
import 'select_region_page.dart';

class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Image.asset(
              'images/halfofthing_logo.png',
              width: 100,
              height: 100,
              color: Colors.white,
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    child: Form(
//                  key: _nameFormKey,
                      child: TextFormField(
                        onChanged: (String str) {
                          setState(() {
//                        _name = str;
                          });
                        },
                        keyboardType: TextInputType.text,
//                    controller: _nameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: '핸드폰번호',
                            border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '핸드폰번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 15,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                    child: Form(
//                  key: _nameFormKey,
                      child: TextFormField(
                        onChanged: (String str) {
                          setState(() {
//                        _name = str;
                          });
                        },
                        keyboardType: TextInputType.text,
//                    controller: _nameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            hintText: '비밀번호',
                            border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Select_Region_Page()));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 15,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      child: Container(
                          height: 50,
                          child: Center(
                              child: Text(
                            '로그인',
                            style: text_grey_20(),
                          ))),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Add_Account_Page()));
                },
                  child: Text(
                '반띵이 처음이신가요?',
                style: text_white_20(),
              )),
              Container(
                height: 30,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Find_Password_Page()));
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: text_white_15(),
                  )),
            ],
          ),
//          Padding(
//            padding: const EdgeInsets.symmetric(horizontal: 80),
//            child: Column(
//              children: <Widget>[
//                Text(
//                  'or login with',
//                  style: text_white_20(),
//                ),
//                Container(
//                  height: 20,
//                ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
//                  children: <Widget>[
//                    GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                  builder: (context) => User_Map_Page()));
//                        },
//                        child: Image.asset(
//                          'images/google_logo_400x400.png',
//                          width: 50,
//                          height: 50,
//                        )),
//                    GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                  builder: (context) => User_Map_Page()));
//                        },
//                        child: Image.asset(
//                          'images/apple_logo_400x400.png',
//                          width: 50,
//                          height: 50,
//                        )),
//                    GestureDetector(
//                        onTap: () {
//                          Navigator.of(context).pushReplacement(
//                              MaterialPageRoute(
//                                  builder: (context) => User_Map_Page()));
//                        },
//                        child: Image.asset(
//                          'images/facebook_logo_400x400.png',
//                          width: 50,
//                          height: 50,
//                        )),
//                  ],
//                ),
//              ],
//            ),
//          )
        ],
      ),
    );
  }
}
