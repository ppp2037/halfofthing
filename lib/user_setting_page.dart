import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_Setting_Page extends StatefulWidget {
  @override
  _User_Setting_PageState createState() => _User_Setting_PageState();
}

class _User_Setting_PageState extends State<User_Setting_Page> {
  String _userPhoneNumber;
  String _userLocation;
  bool _isNotificationChecked = false;

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
        body: ListView(
          children: <Widget>[
            StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection('사용자')
                  .document(_userPhoneNumber)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  Map<String, dynamic> documentFields = snapshot.data.data;
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.account_circle,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(snapshot.data['이름'], style: text_grey_20()),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data['위치'],
                                  style: text_grey_20(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 10,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '이용횟수',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.apps,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      '이용횟수 : ' + snapshot.data['이용횟수'].toString(),
                                      style: text_grey_15(),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '이용방법',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.library_books,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      '이용방법',
                                      style: text_grey_15(),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '공지사항',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.notifications,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      '공지사항',
                                      style: text_grey_15(),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '신고하기',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.warning,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      '신고하기',
                                      style: text_grey_15(),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: '고객지원',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.help_outline,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    Container(
                                      width: 10,
                                    ),
                                    Text(
                                      '고객지원',
                                      style: text_grey_15(),
                                    ),
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.notifications_active,
                              color: Colors.grey,
                              size: 25,
                            ),
                            Container(
                              width: 10,
                            ),
                            Text('푸시알림',style: text_grey_15(),),
                            Container(
                              width: 10,
                            ),
                            Switch(
                              value: _isNotificationChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isNotificationChecked = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            (() async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              setState(() {
                                prefs.clear();
                              });
                            })();
                            Fluttertoast.showToast(
                                msg: '로그아웃 되었습니다',
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.pink,
                                textColor: Colors.white);
                            Phoenix.rebirth(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.clear,
                                  color: Colors.grey,
                                  size: 25,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Text(
                                  '로그아웃',
                                  style: text_grey_15(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 20,
                        ),
                        Text(
                          'Copyright © 2020 gauntlet Inc.',
                          style: text_grey_10(),
                        ),
                        Container(
                          height: 10,
                        ),
                        Text(
                          'All Rights Reserved. Ver 1.0.0',
                          style: text_grey_10(),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ));
  }
}
