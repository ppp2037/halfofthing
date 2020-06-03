import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:search_widget/search_widget.dart';

import 'settings/university_list.dart';

class Add_Account_Page extends StatefulWidget {
  @override
  _Add_Account_PageState createState() => _Add_Account_PageState();
}

class _Add_Account_PageState extends State<Add_Account_Page> {
  LeaderBoard _selectedItem;
  bool _isItemSelected = false;
  bool _isRegionSelected = false;

  final GlobalKey<FormState> _nameFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final GlobalKey<FormState> _phoneNumberFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final GlobalKey<FormState> _passwordFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 이름 폼 키 생성
  final GlobalKey<FormState> _passwordCheckFormKey =
      GlobalKey<FormState>(); //글로벌 키 => 이름 폼 키 생성

  final TextEditingController _nameController =
      TextEditingController(); //컨트롤러 생성
  final TextEditingController _phoneNumberController =
      TextEditingController(); //컨트롤러 생성
  final TextEditingController _passwordController =
      TextEditingController(); //컨트롤러 생성
  final TextEditingController _passwordCheckController =
      TextEditingController(); //컨트롤러 생성

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _passwordCheckController.dispose();
    super.dispose();
  }

  String _name;
  String _phoneNumber; // 사용자가 입력한 핸드폰번호 값
  String _password; // 사용자가 입력한 비밀번호 값
  String _passwordCheck;

  String _comparePhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('회원가입'),
        centerTitle: true,
      ),
      body: _isRegionSelected
          ? Column(
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
                        key: _nameFormKey,
                        child: TextFormField(
                          onChanged: (String str) {
                            setState(() {
                              _name = str;
                            });
                          },
                          keyboardType: TextInputType.text,
                          controller: _nameController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.account_circle),
                              hintText: '이름',
                              border: InputBorder.none),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return '이름을 입력해주세요';
                            }
                            if (value.length == 1) {
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
                        key: _passwordCheckFormKey,
                        child: TextFormField(
                          obscureText: true,
                          onChanged: (String str) {
                            setState(() {
                              _passwordCheck = str;
                            });
                          },
                          keyboardType: TextInputType.text,
                          controller: _passwordCheckController,
                          decoration: InputDecoration(
                              icon: Icon(Icons.lock),
                              hintText: '비밀번호 확인',
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
                    if (_nameFormKey.currentState.validate()) {
                      if (_phoneNumberFormKey.currentState.validate()) {
                        if (_passwordFormKey.currentState.validate()) {
                          if (_passwordCheckFormKey.currentState.validate()) {
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
                                                  BorderRadius.circular(20)),
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
                                                      style: text_grey_15()),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Text(_name,
                                                      style: text_grey_15()),
                                                ],
                                              ),
                                              Container(
                                                height: 15,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text('핸드폰번호 :',
                                                      style: text_grey_15()),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Text(_phoneNumber,
                                                      style: text_grey_15()),
                                                ],
                                              ),
                                              Container(
                                                height: 15,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text('위치 :',
                                                      style: text_grey_15()),
                                                  Container(
                                                    width: 10,
                                                  ),
                                                  Text(_selectedItem.location,
                                                      style: text_grey_15()),
                                                ],
                                              ),
                                              Container(
                                                height: 40,
                                              ),
                                              Text('위의 정보로 등록하시겠어요?',
                                                  style: text_grey_15()),
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
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
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
                                                                  text_grey_15()),
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
                                                        '핸드폰번호': _phoneNumber,
                                                        '위치': _selectedItem
                                                            .location,
                                                        '비밀번호': _password,
                                                        '로그인여부': 'N',
                                                        '인증여부': 'N',
                                                        '이용횟수': 0,
                                                      });
                                                      Navigator.of(
                                                          context)
                                                          .popUntil((route) =>
                                                      route
                                                          .isFirst);
                                                      Fluttertoast.showToast(
                                                          msg: '회원가입에 성공했어요',
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.pink,
                                                          textColor:
                                                              Colors.white);
                                                    },
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
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
                                                                  text_grey_15()),
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
                                  Fluttertoast.showToast(msg: '핸드폰번호가 중복되었어요',
                                      gravity: ToastGravity
                                          .CENTER,
                                      backgroundColor:
                                      Colors.pink,
                                      textColor:
                                      Colors.white);
                                }
                              });
                            } else {
                              Fluttertoast.showToast(
                                  msg: '비밀번호가 일치하지 않아요',
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.pink,
                                  textColor: Colors.white);
                            }
                          } else {}
                        } else {}
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
                              '회원가입',
                              style: text_white_20(),
                            ))),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: '핸드폰 인증 구현',
                        gravity: ToastGravity.CENTER,
                        backgroundColor: Colors.pink,
                        textColor: Colors.white);
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
                              '테스트 인증하기',
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
                  style: text_grey_15(),
                ),
                Container(
                  height: 30,
                ),
                SearchWidget<LeaderBoard>(
                  dataList: list,
                  hideSearchBoxWhenItemSelected: true,
                  listContainerHeight: MediaQuery.of(context).size.height / 2,
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
                    return SelectedItemWidget(selectedItem, deleteSelectedItem);
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
                          borderRadius: BorderRadius.circular(20)),
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
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
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
              child: Text(
                selectedItem.location,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        showCursor: true,
        cursorColor: Colors.pink,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
//          hintText: "반띵대학교...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
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
        Text(
          '검색 결과가 없어요',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
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
      child: Text(
        item.location,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
