import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:search_widget/search_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'settings/make_password_encryption.dart';
import 'settings/university_list.dart';

class Add_Account_Page extends StatefulWidget {
  @override
  _Add_Account_PageState createState() => _Add_Account_PageState();
}

class _Add_Account_PageState extends State<Add_Account_Page> {
  LeaderBoard _selectedItem;
  bool _isItemSelected = false;
  bool _isRegionSelected = false;
  bool _isPersonalInfoPermission = true;
  bool _isPhoneValidate = false;
  bool _isPhoneValidateClicked = false;
  bool _isPhoneValidateDone = false;

  final GlobalKey<FormState> _nameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneNumberFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _phoneNumberValidateFormKey =
      GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordCheckFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _phoneNumberValidateController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordCheckController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _phoneNumberValidateController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  String _name;
  String _phoneNumber;
  String _phoneNumberValidate;
  String _password;
  String _passwordCheck;
  String _comparePhoneNumber;
  String _verificationId;
  String _phoneNumberForValidate;

  var _ivsalt = make_ivslat();
  var _fortuna_key = make_key();

  void _requestSMSCodeUsingPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: _phoneNumberForValidate,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential phoneAuthCredential) =>
            print('Sign up with phone complete'),
        verificationFailed: (AuthException error) =>
            print('error message is ${error.message}'),
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() => _verificationId = verificationId);
        },
        codeAutoRetrievalTimeout: null);
  }

  void _signInWithPhoneNumberAndSMSCode() async {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _phoneNumberValidate);
    final FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(authCreds)).user;

//    setState(() => _verificationId = null);
//    FocusScope.of(context).requestFocus(FocusNode());
//    _showSnackBar('Sign up with phone success. Check your firebase.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: text_pink_20(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: _isPersonalInfoPermission
          ? Column(
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
                        Text('로그인, 반띵 서비스 이용', style: text_grey_15()),
                        Container(
                          height: 30,
                        ),
                        Text('2. 수집 항목', style: text_darkgrey_20()),
                        Container(
                          height: 10,
                        ),
                        Text('(필수) 이름, 핸드폰 번호, 암호화된 비밀번호, 학교',
                            style: text_grey_15()),
                        Container(
                          height: 30,
                        ),
                        Text('3. 보유기간', style: text_darkgrey_20()),
                        Container(
                          height: 10,
                        ),
                        Text('회원 가입시부터 회원 탈퇴시까지', style: text_grey_15()),
                        Container(
                          height: 10,
                        ),
                        Text('반띵 앱을 이용하기 위한', style: text_grey_15()),
                        Container(
                          height: 10,
                        ),
                        Text('최소한의 개인정보만 수집합니다.', style: text_grey_15()),
                        Container(
                          height: 10,
                        ),
                        Text('동의를 하면 회원가입이 가능합니다.', style: text_grey_15()),
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
                            Text('동의하고 시작하기', style: text_white_20())
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
          : _isRegionSelected
              ? Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, top: 20, bottom: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        elevation: 15,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 5, bottom: 5),
                          child: Form(
                            key: _nameFormKey,
                            child: TextFormField(
                              style: text_darkgrey_15(),
                              onChanged: (String str) {
                                setState(() {
                                  _name = str.trim();
                                });
                              },
                              keyboardType: TextInputType.text,
                              controller: _nameController,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.account_circle,
                                    color: Colors.grey[700],
                                  ),
                                  hintText: '이름',
                                  hintStyle: text_grey_15(),
                                  border: InputBorder.none),
                              validator: (String value) {
                                if (value.trim().isEmpty) {
                                  return '이름을 입력해주세요';
                                }
                                if (value.trim().length == 1) {
                                  return '올바른 이름을 입력해주세요';
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
                      child: Stack(
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            elevation: 15,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 5, bottom: 5),
                              child: Form(
                                key: _phoneNumberFormKey,
                                child: TextFormField(
                                  enabled: _isPhoneValidateDone ? false : true,
                                  style: text_darkgrey_15(),
                                  onChanged: (String str) {
                                    setState(() {
                                      _phoneNumber = str.trim();
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: _phoneNumberController,
                                  decoration: InputDecoration(
                                      icon: Icon(
                                        Icons.phone,
                                        color: Colors.grey[700],
                                      ),
                                      hintText: '핸드폰번호',
                                      hintStyle: text_grey_15(),
                                      border: InputBorder.none),
                                  validator: (String value) {
                                    if (value.trim().isEmpty) {
                                      return '핸드폰번호를 입력해주세요';
                                    }
                                    if (value.trim().length != 11) {
                                      return '올바른 핸드폰번호를 입력해주세요';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          _isPhoneValidateDone
                              ? Positioned(
                                  top: 20,
                                  right: 20,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.pink,
                                  ))
                              : Positioned(
                                  top: 25,
                                  right: 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_phoneNumberFormKey.currentState
                                          .validate()) {
                                        setState(() {
                                          _isPhoneValidateClicked =
                                              !_isPhoneValidateClicked;
                                        });
                                        _phoneNumberForValidate = "+82" +
                                            _phoneNumber.substring(1, 11);
                                        _requestSMSCodeUsingPhoneNumber();
                                      }
                                    },
                                    child: Text(
                                      '인증하기',
                                      style: text_grey_15(),
                                    ),
                                  )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isPhoneValidateClicked ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 20),
                        child: Stack(
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60)),
                              elevation: 15,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, top: 5, bottom: 5),
                                child: Form(
                                  key: _phoneNumberValidateFormKey,
                                  child: TextFormField(
                                    style: text_darkgrey_15(),
                                    onChanged: (String str) {
                                      setState(() {
                                        _phoneNumberValidate = str.trim();
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    controller: _phoneNumberValidateController,
                                    decoration: InputDecoration(
                                        icon: Icon(
                                          Icons.check,
                                          color: Colors.grey[700],
                                        ),
                                        hintText: '인증번호',
                                        hintStyle: text_grey_15(),
                                        border: InputBorder.none),
                                    validator: (String value) {
                                      if (value.trim().isEmpty) {
                                        return '인증번호를 입력해주세요';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 25,
                                right: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    if (_phoneNumberValidateFormKey.currentState
                                        .validate()) {
                                      setState(() {
                                        _isPhoneValidateClicked =
                                            !_isPhoneValidateClicked;
                                        _isPhoneValidateDone =
                                            !_isPhoneValidateDone;
                                      });
                                      _signInWithPhoneNumberAndSMSCode();
                                    }
                                  },
                                  child: Text(
                                    '확인',
                                    style: text_grey_15(),
                                  ),
                                )),
                          ],
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
                            key: _passwordFormKey,
                            child: TextFormField(
                              style: TextStyle(
                                  fontFamily: 'Spoqa_Han_Sans_Regular',
                                  color: Colors.grey[700]),
                              obscureText: true,
                              onChanged: (String str) {
                                setState(() {
                                  _password = str.trim();
                                });
                              },
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[700],
                                  ),
                                  hintText: '비밀번호',
                                  hintStyle: text_grey_15_for_password(),
                                  border: InputBorder.none),
                              validator: (String value) {
                                if (value.trim().isEmpty) {
                                  return '비밀번호를 입력해주세요';
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
                            key: _passwordCheckFormKey,
                            child: TextFormField(
                              style: TextStyle(
                                  fontFamily: 'Spoqa_Han_Sans_Regular',
                                  color: Colors.grey[700]),
                              obscureText: true,
                              onChanged: (String str) {
                                setState(() {
                                  _passwordCheck = str.trim();
                                });
                              },
                              keyboardType: TextInputType.text,
                              controller: _passwordCheckController,
                              decoration: InputDecoration(
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.grey[700],
                                  ),
                                  hintText: '비밀번호 확인',
                                  hintStyle: text_grey_15_for_password(),
                                  border: InputBorder.none),
                              validator: (String value) {
                                if (value.trim().isEmpty) {
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
                        if (_nameFormKey.currentState.validate()) {
                          if (_phoneNumberFormKey.currentState.validate()) {
                            if (_passwordFormKey.currentState.validate()) {
                              if (_passwordCheckFormKey.currentState
                                  .validate()) {
                                if (_password == _passwordCheck) {
                                  Firestore.instance
                                      .collection('사용자')
                                      .where('핸드폰번호', isEqualTo: _phoneNumber)
                                      .getDocuments()
                                      .then((QuerySnapshot ds) {
                                    ds.documents.forEach((doc) =>
                                        _comparePhoneNumber = doc['핸드폰번호']);
                                    if (_comparePhoneNumber != _phoneNumber) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text('회원가입',
                                                      style: text_pink_20()),
                                                  Container(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('이름 :',
                                                          style:
                                                              text_darkgrey_15()),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      Text(_name,
                                                          style:
                                                              text_darkgrey_15()),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('핸드폰번호 :',
                                                          style:
                                                              text_darkgrey_15()),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      Text(_phoneNumber,
                                                          style:
                                                              text_darkgrey_15()),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Text('위치 :',
                                                          style:
                                                              text_darkgrey_15()),
                                                      Container(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                          _selectedItem
                                                              .location,
                                                          style:
                                                              text_darkgrey_15()),
                                                    ],
                                                  ),
                                                  Container(
                                                    height: 40,
                                                  ),
                                                  Text('위의 정보로 등록하시겠어요?',
                                                      style:
                                                          text_darkgrey_15()),
                                                  Container(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60)),
                                                          elevation: 5,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 25,
                                                                    right: 25,
                                                                    top: 15,
                                                                    bottom: 15),
                                                            child: Center(
                                                              child: Text('취소',
                                                                  style:
                                                                      text_darkgrey_15()),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          Firestore.instance
                                                              .collection('사용자')
                                                              .document(
                                                                  _phoneNumber)
                                                              .setData({
                                                            '이름': _name,
                                                            '핸드폰번호':
                                                                _phoneNumber,
                                                            '위치': _selectedItem
                                                                .location,
                                                            'ivsalt': _ivsalt,
                                                            'key': _fortuna_key,
                                                            '비밀번호':
                                                                make_encryption(
                                                                    _password,
                                                                    _ivsalt,
                                                                    _fortuna_key),
                                                            '인증여부': 'N',
                                                            '이용횟수': 0,
                                                            '채팅중인방ID': '',
                                                          });
                                                          Fluttertoast
                                                              .showToast(
                                                            msg: '회원가입에 성공했어요',
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.white,
                                                            textColor:
                                                                Colors.pink,
                                                          );
                                                          Phoenix.rebirth(
                                                              context);
                                                        },
                                                        child: Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60)),
                                                          elevation: 5,
                                                          color: Colors.white,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 25,
                                                                    right: 25,
                                                                    top: 15,
                                                                    bottom: 15),
                                                            child: Center(
                                                              child: Text('확인',
                                                                  style:
                                                                      text_darkgrey_15()),
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
                                    } else {
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
                                                      BorderRadius.circular(
                                                          20)),
                                              content: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Center(
                                                      child: Text(
                                                    '핸드폰번호가 중복되었어요',
                                                    style: text_darkgrey_20(),
                                                  )),
                                                ),
                                              ),
                                            );
                                          });
                                    }
                                  });
                                } else {
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
                                                '비밀번호가 일치하지 않아요',
                                                style: text_darkgrey_20(),
                                              )),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              } else {}
                            } else {}
                          } else {}
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
                            padding: const EdgeInsets.only(top: 5, bottom: 5),
                            child: Container(
                                height: 50,
                                child: Center(
                                    child: Text(
                                  '회원가입',
                                  style: text_white_20(),
                                ))),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                    ),
                    Text(
                      '학교를 선택해주세요',
                      style: text_darkgrey_15(),
                    ),
                    Container(
                      height: 30,
                    ),
                    SearchWidget<LeaderBoard>(
                      dataList: list,
                      hideSearchBoxWhenItemSelected: true,
                      listContainerHeight:
                          MediaQuery.of(context).size.height / 2,
                      queryBuilder: (query, list) {
                        return list
                            .where((item) => item.location
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                            .toList();
                      },
                      popupListItemBuilder: (item) {
                        return PopupListItemWidget(item);
                      },
                      selectedItemBuilder: (selectedItem, deleteSelectedItem) {
                        return SelectedItemWidget(
                            selectedItem, deleteSelectedItem);
                      },
                      // widget customization
                      noItemsFoundWidget: NoItemsFound(),
                      textFieldBuilder: (controller, focusNode) {
                        return MyTextField(controller, focusNode);
                      },
                      onItemSelected: (item) {
                        setState(() {
                          _selectedItem = item;
                          _isItemSelected = !_isItemSelected;
                        });
                      },
                    ),
                    Container(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isItemSelected
                              ? _isRegionSelected = !_isRegionSelected
                              : () {};
                        });
                      },
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60)),
                          elevation: 15,
                          color: _isItemSelected ? Colors.pink : Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 15, bottom: 15),
                            child: Center(
                                child: Text(
                              '확인',
                              style: text_white_20(),
                            )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}

class LeaderBoard {
  LeaderBoard(this.location);

  final String location;
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final LeaderBoard selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 8,
                ),
                child: Text(selectedItem.location, style: text_darkgrey_15()),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              color: Colors.grey[700],
              onPressed: deleteSelectedItem,
            ),
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        elevation: 15,
        child: Container(
          height: 60,
          child: Center(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              showCursor: true,
              cursorColor: Colors.pink,
              style: text_darkgrey_15(),
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[700],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(
                  left: 16,
                  right: 20,
                  top: 14,
                  bottom: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text('검색 결과가 없어요', style: text_darkgrey_15()),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final LeaderBoard item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(item.location, style: text_darkgrey_15()),
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
