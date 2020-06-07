import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings/styles.dart';

class User_Settings_Feedback_Page extends StatefulWidget {
  @override
  _User_Settings_Feedback_PageState createState() => _User_Settings_Feedback_PageState();
}

class _User_Settings_Feedback_PageState extends State<User_Settings_Feedback_Page> {

  final GlobalKey<FormState> _feedbackFormKey =
  GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _feedbackController =
  TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String _feedback;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('개선사항'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
          ),
          Column(
            children: <Widget>[
              Text(
                '반띵의 개선사항을 적어주세요',
                style: text_grey_15(),
              ),
              Container(
                height: 20,
              ),
              Text(
                '여러분의 참여가 큰 도움이 돼요',
                style: text_grey_15(),
              ),
            ],
          ),
          Container(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 40, right: 40, bottom: 20),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5),
                  child: Form(
                    key: _feedbackFormKey,
                    child: TextFormField(
                      onChanged: (String str) {
                        setState(() {
                          _feedback = str;
                        });
                      },
                      keyboardType: TextInputType.text,
                      maxLines: null,
                      controller: _feedbackController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.edit),
                          border: InputBorder.none),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '개선사항을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (_feedbackFormKey.currentState.validate()) {
                var _currentTime = DateTime.now();
                var _userOrderId =
                DateFormat('yyyyMMddHHmmss').format(_currentTime);
                Firestore.instance
                    .collection('피드백')
                    .document(_userPhoneNumber + '_' + _userOrderId)
                    .setData({
                  '피드백': _feedback,
                  '위치': _userLocation,
                  '사용자핸드폰번호': _userPhoneNumber,
                  '피드백이름': _userPhoneNumber + '_' + _userOrderId,
                });
                Fluttertoast.showToast(
                    msg: '개선사항에 도움을 주셔서 감사합니다',
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.pink,
                    textColor: Colors.white);
                Navigator.of(context).pop();
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
                      top: 5, bottom: 5),
                  child: Container(
                      height: 50,
                      child: Center(
                          child: Text(
                            '완료',
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
