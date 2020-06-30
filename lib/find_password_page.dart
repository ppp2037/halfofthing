import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings/styles.dart';

class Find_Password_Page extends StatefulWidget {
  @override
  _Find_Password_PageState createState() => _Find_Password_PageState();
}

class _Find_Password_PageState extends State<Find_Password_Page> {
  final GlobalKey<FormState> _phoneNumberFormKey =
  GlobalKey<FormState>();
  final TextEditingController _phoneNumberController =
  TextEditingController();

  bool _isPersonalInfoPermission = true;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('비밀번호 찾기', style: text_pink_20(),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.pink),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body:
      _isPersonalInfoPermission ?
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('개인정보 수집 및 이용 동의', style: text_darkgrey_25()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 20,
                  ),
                  Text('1. 수집 목적', style: text_darkgrey_20()),
                  Container(
                    height: 10,
                  ),
                  Text('비밀번호 찾기', style: text_grey_15()),
                  Container(
                    height: 30,
                  ),
                  Text('2. 수집 항목', style: text_darkgrey_20()),
                  Container(
                    height: 10,
                  ),
                  Text('(필수) 이름, 핸드폰 번호',
                      style: text_grey_15()),
                  Container(
                    height: 30,
                  ),
                  Text('3. 보유기간', style: text_darkgrey_20()),
                  Container(
                    height: 10,
                  ),
                  Text('비밀번호 찾기를 위한', style: text_grey_15()),
                  Container(
                    height: 10,
                  ),
                  Text('최소한의 개인정보만 수집합니다.', style: text_grey_15()),
                  Container(
                    height: 10,
                  ),
                  Text('동의를 하면 비밀번호 찾기가 가능합니다.', style: text_grey_15()),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isPersonalInfoPermission = !_isPersonalInfoPermission;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Card(
                color: Colors.pink,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60)),
                elevation: 15,
                child: Container(
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('동의하기', style: text_white_20())
                    ],
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: launchUrl,
            child: Container(
              width: 200,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('개인정보 처리방침', style: text_grey_15()),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(left: 40, right: 40, bottom: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60)),
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
          GestureDetector(
            onTap: () {
              if (_phoneNumberFormKey.currentState.validate()) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      Future.delayed(Duration(seconds: 2),
                              () {
                            Navigator.pop(context);
                          });
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                        content: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Center(
                                child: Text(
                                  '핸드폰번호 인증에 성공했어요',
                                  style: text_darkgrey_20(),
                                )),
                          ),
                        ),
                      );
                    });
                      Navigator.pop(context);
                    } else {
                    }
            },
            child: Padding(
              padding:
              const EdgeInsets.only(left: 40, right: 40, bottom: 20),
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
                            '인증하기',
                            style: text_white_20(),
                          ))),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
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
