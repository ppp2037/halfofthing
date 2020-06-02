import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';

import 'add_account_page.dart';
import 'background_page.dart';
import 'find_password_page.dart';

class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> {
  final GlobalKey<FormState> _phoneNumberFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final GlobalKey<FormState> _passwordFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 이름 폼 키 생성
  final TextEditingController _phoneNumberController =
      TextEditingController(); //컨트롤러 생성
  final TextEditingController _passwordController =
      TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _phoneNumber; // 사용자가 입력한 핸드폰번호 값
  String _password; // 사용자가 입력한 비밀번호 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Flexible(
            child: Image.asset(
              'images/halfofthing_logo.png',
              width: 100,
              height: 100,
              color: Colors.pink,
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
                      key: _phoneNumberFormKey,
                      child: TextFormField(
                        onChanged: (String str) {
                          setState(() {
                            _phoneNumber = str;
                          });
                        },
                        keyboardType: TextInputType.number,
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.phone),
                            hintText: '핸드폰번호',
                            border: InputBorder.none),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '핸드폰번호를 입력해주세요';
                          }
                          if (value.length != 11) {
                            return '올바른 핸드폰번호를 입력해주세요';
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
                      key: _passwordFormKey,
                      child: TextFormField(
                        obscureText: true,
                        onChanged: (String str) {
                          setState(() {
                            _password = str;
                          });
                        },
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
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
                  if (_phoneNumberFormKey.currentState.validate() == true) {
                    if (_passwordFormKey.currentState.validate() == true) {


                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Background_Page()));
                    } else {}
                  } else {}
                },
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 40, right: 40, bottom: 20),
                  child: Card(
                    color: Colors.pink,
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
                            style: text_white_20(),
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
                    style: text_grey_15(),
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
                    style: text_grey_15(),
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
