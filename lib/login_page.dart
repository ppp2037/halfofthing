import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_account_page.dart';
import 'background_page.dart';
import 'find_password_page.dart';
import 'settings/make_password_encryption.dart';

class Login_Page extends StatefulWidget {
  @override
  _Login_PageState createState() => _Login_PageState();
}

class _Login_PageState extends State<Login_Page> with TickerProviderStateMixin {
  String _userPhoneNumber;
  String _userLocation;
  String _comparePhoneNumber;
  String _comparePassword;

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
    _bounceInOutController.dispose();
    _fastOutSlowInController.dispose();
    super.dispose();
  }

  String _phoneNumber; // 사용자가 입력한 핸드폰번호 값
  String _password; // 사용자가 입력한 비밀번호 값

  String _iv_salt;
  String _fortuna_key;

  AnimationController _bounceInOutController;
  Animation _bounceInOutAnimation;

  AnimationController _fastOutSlowInController;
  Animation _fastOutSlowInAnimation;

  @override
  void initState() {
    super.initState();
    _bounceInOutController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _bounceInOutController.forward();
    _fastOutSlowInController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _fastOutSlowInController.forward();
  }

  @override
  Widget build(BuildContext context) {
    _bounceInOutAnimation = CurvedAnimation(
        parent: _bounceInOutController, curve: Curves.bounceInOut);
    _bounceInOutAnimation.addListener(() {
      setState(() {});
    });
    _fastOutSlowInAnimation = CurvedAnimation(
        parent: _fastOutSlowInController, curve: Curves.fastOutSlowIn);
    _fastOutSlowInAnimation.addListener(() {
      setState(() {});
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'images/halfofthing_logo.png',
            color: Colors.pink,
            width:
                Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
            height:
                Tween(begin: 0.0, end: 100.0).evaluate(_bounceInOutAnimation),
          ),
          Column(
            children: <Widget>[
              Container(
                width: Tween(begin: 0.0, end: MediaQuery.of(context).size.width)
                    .evaluate(_fastOutSlowInAnimation),
                height: Tween(
                        begin: 0.0, end: MediaQuery.of(context).size.height / 8)
                    .evaluate(_fastOutSlowInAnimation),
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
                              hintStyle: text_grey_15(),
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
              ),
              Container(
                width: Tween(begin: 0.0, end: MediaQuery.of(context).size.width)
                    .evaluate(_fastOutSlowInAnimation),
                height: Tween(
                        begin: 0.0, end: MediaQuery.of(context).size.height / 8)
                    .evaluate(_fastOutSlowInAnimation),
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
                              hintStyle: text_grey_15(),
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
              ),
              Container(
                width: Tween(begin: 0.0, end: MediaQuery.of(context).size.width)
                    .evaluate(_bounceInOutAnimation),
                height: Tween(
                        begin: 0.0, end: MediaQuery.of(context).size.height / 8)
                    .evaluate(_bounceInOutAnimation),
                child: GestureDetector(
                  onTap: () {
                    if (_phoneNumberFormKey.currentState.validate()) {
                      if (_passwordFormKey.currentState.validate()) {
                        Firestore.instance
                            .collection('사용자')
                            .where('핸드폰번호', isEqualTo: _phoneNumber)
                            .getDocuments()
                            .then((QuerySnapshot ds) {
                          ds.documents.forEach((doc) {
                            _comparePhoneNumber = doc['핸드폰번호'];
                            _comparePassword = doc['비밀번호'];
                            _userLocation = doc['위치'];
                            _iv_salt = doc['ivsalt'];
                            _fortuna_key = doc['key'];
                          });
                          if (_comparePhoneNumber == _phoneNumber &&
                              _comparePassword == make_encryption(_password, _iv_salt, _fortuna_key)) {
                            (() async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                prefs.setString(
                                    'prefsPhoneNumber', _phoneNumber);
                                prefs.setString('prefsLocation', _userLocation);
                              });
                            })();
                            Fluttertoast.showToast(
                                msg: '로그인 되었어요',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => Background_Page()));
                          } else {
                            Fluttertoast.showToast(
                                msg: '로그인정보가 일치하지 않아요',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          }
                        });
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
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
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
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                width: Tween(begin: 0.0, end: MediaQuery.of(context).size.width)
                    .evaluate(_fastOutSlowInAnimation),
                height: Tween(
                        begin: 0.0, end: MediaQuery.of(context).size.height / 8)
                    .evaluate(_fastOutSlowInAnimation),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Add_Account_Page()));
                    },
                    child: Center(
                      child: Text(
                        '반띵이 처음이신가요?',
                        style: text_grey_15(),
                      ),
                    )),
              ),
              Container(
                height: 40,
              ),
              Container(
                width: Tween(begin: 0.0, end: MediaQuery.of(context).size.width)
                    .evaluate(_fastOutSlowInAnimation),
                height: Tween(
                        begin: 0.0, end: MediaQuery.of(context).size.height / 8)
                    .evaluate(_fastOutSlowInAnimation),
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Find_Password_Page()));
                    },
                    child: Center(
                      child: Text(
                        '비밀번호 찾기',
                        style: text_grey_15(),
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
