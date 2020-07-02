import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings/styles.dart';
import 'package:intl/intl.dart';

class User_History_Page extends StatefulWidget {
  @override
  _User_History_PageState createState() => _User_History_PageState();
}

class _User_History_PageState extends State<User_History_Page> {
  String _userPhoneNumber;

  @override
  void initState() {
    super.initState();
    (() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _userPhoneNumber = prefs.getString('prefsPhoneNumber');
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          '주문내역',
          style: text_pink_20(),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('history')
            .where('orderUsers', arrayContains: _userPhoneNumber)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          if (snapshot.data.documents.isEmpty) {
            return Center(child: Text('주문 내역이 없어요', style: text_grey_15()));
          }
          return _buildList(context, snapshot.data.documents);
        },
      ),
    );
  }
}

Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  snapshot.sort((a, b) => Record.fromSnapshot(a)
      .orderDate
      .compareTo(Record.fromSnapshot(b).orderDate));

  return ListView(
    padding: const EdgeInsets.only(bottom: 20.0),
    children: snapshot.map((data) => _buildListItem(context, data)).toList(),
  );
}

Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);
  var format = DateFormat('yyyy년 MM월 dd일');
  DateTime date = (record.orderDate).toDate();
  var orderDateStr = format.format(date);

  return Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    record.restaurant,
                    style: text_darkgrey_20(),
                  ),
                  Text(
                    orderDateStr,
                    style: text_darkgrey_15(),
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(record.meetingPlace, style: text_darkgrey_15()),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
        ),
      ],
    ),
  );
}

class Record {
  final String restaurant;
  final String meetingPlace;
  var orderDate;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['restaurant'] != null),
        assert(map['orderTime'] != null),
        assert(map['meetingPlace'] != null),
        restaurant = map['restaurant'],
        meetingPlace = map['meetingPlace'],
        orderDate = map['orderTime'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}
