import 'package:flutter/material.dart';

import 'login_page.dart';

void main() => runApp(Halfofthing());

class Halfofthing extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '반띵',
      theme: ThemeData(
          primarySwatch: Colors.pink, fontFamily: 'Spoqa_Han_Sans_Regular'),
      home: Login_Page(),
    );
  }
}
