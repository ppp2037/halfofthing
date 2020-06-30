import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'background_page.dart';
import 'login_page.dart';

final FirebaseMessaging fcm = FirebaseMessaging();

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
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    fcm.getToken().then((token) {
      print('token:' + token);
    });

    fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '반띵',
      theme: ThemeData(
          primarySwatch: Colors.pink,
          fontFamily: 'BMEULJIROTTF',
          brightness: Brightness.light),
      // darkTheme: ThemeData(
      //     primarySwatch: Colors.pink,
      //     fontFamily: 'Spoqa_Han_Sans_Regular',
      //     brightness: Brightness.dark),
      home: _userIsLogin ? Login_Page() : Background_Page(),
    );
  }
}
