import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:halfofthing/screens/dashboard.dart';
import 'package:halfofthing/screens/loginpage.dart';

class AuthService {


  //final String origin_phoneNo;

  //Handles Auth
  handleAuth(origin_phoneNo) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return DashboardPage();
          } else {
            return LoginPage(origin_phoneNo);
          }
        });
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  signIn(AuthCredential authCreds) {
    FirebaseAuth.instance.signInWithCredential(authCreds);
  }

  signInWithOTP(smsCode, verId) {
    AuthCredential authCreds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    signIn(authCreds);
  }
}