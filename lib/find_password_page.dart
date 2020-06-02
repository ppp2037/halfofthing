import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'settings/styles.dart';

class Find_Password_Page extends StatefulWidget {
  @override
  _Find_Password_PageState createState() => _Find_Password_PageState();
}

class _Find_Password_PageState extends State<Find_Password_Page> {
  final GlobalKey<FormState> _phoneNumberFormKey =
  GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _phoneNumberController =
  TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  String _phoneNumber; // 사용자가 입력한 핸드폰번호 값

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
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
                      Fluttertoast.showToast(
                          msg: '인증에 성공했어요',
                          gravity: ToastGravity.CENTER,
                          backgroundColor: Colors.pink,
                          textColor: Colors.white);
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
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                child: Padding(
                  padding:
                  const EdgeInsets.only(left: 15, top: 5, bottom: 5),
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
