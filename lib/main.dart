import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_page.dart';
import 'login_page.dart';

void main() => runApp(Phoenix(child: Halfofthing()));

class Halfofthing extends StatefulWidget {
  @override
  _HalfofthingState createState() => _HalfofthingState();
}

class _HalfofthingState extends State<Halfofthing> {
  String _userPhoneNumber;
  bool _userIsLogin = true;

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
        if (_userPhoneNumber.isNotEmpty) {
          _userIsLogin = !_userIsLogin;
        }
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '반띵',
      theme: ThemeData(
          primarySwatch: Colors.pink, fontFamily: 'Spoqa_Han_Sans_Regular'),
      home: _userIsLogin ? Login_Page() : Background_Page(),
    );
  }
}