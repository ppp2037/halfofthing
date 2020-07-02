import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:halfofthing/services/authservice.dart';

class LoginPage extends StatefulWidget {

  String origin_phoneNo;
  LoginPage(origin_phoneNo) {
    this.origin_phoneNo = origin_phoneNo;
  }


  @override
  _LoginPageState createState() => _LoginPageState(origin_phoneNo);
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();
  String origin_phoneNo;

  _LoginPageState(origin_phoneNo){
    this.origin_phoneNo = origin_phoneNo;
  }

  String phoneNo;
  String pre_phoneNo;
  String verificationId;
  String smsCode;

  bool codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: '\'-\'를 사용하지 않고 핸드폰 번호를 입력해주세요'),
                    onChanged: (val) {
                      setState(() {
                        this.pre_phoneNo = val;
                        this.phoneNo = "+82" + val.substring(1, 11);
                      });
                    },
                  )),
              codeSent ? Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: '인증번호 6자리를 입력해주세요'),
                    onChanged: (val) {
                      setState(() {
                        this.smsCode = val;
                      });
                    },
                  )) : Container(),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: RaisedButton(
                      child: Center(child: codeSent ? Text('인증번호 입력후 눌러주세요'):Text('인증번호 받기')),
                      onPressed: () {
                        if(origin_phoneNo != pre_phoneNo) {
                          Fluttertoast.showToast(
                              msg: '전에 입력하신 핸드폰 번호와 달라요!',
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.pink,
                              textColor: Colors.white);
                        }
                        //if(FirebaseAuth.instance.ha) {

                        //}
                        else {
                          codeSent ? AuthService().signInWithOTP(
                              smsCode, verificationId) : verifyPhone(phoneNo);
                        }
                      }))
            ],
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
