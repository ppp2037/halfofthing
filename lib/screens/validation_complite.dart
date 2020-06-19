import 'package:flutter/material.dart';
import 'package:halfofthing/services/authservice.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('인증이 완료되었습니다!'),
          onPressed: () {
            Navigator.of(context).pop('True');
            AuthService().signOut();
            //인증이 완료되었으면 로그인 페이지에 알려줘야 함
            return true;
          },
        ),
      ),
    );
  }
}
