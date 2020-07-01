import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'settings/styles.dart';

class User_Settings_Notice_page extends StatefulWidget {
  @override
  _User_Settings_Notice_pageState createState() =>
      _User_Settings_Notice_pageState();
}

class _User_Settings_Notice_pageState extends State<User_Settings_Notice_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('공지사항', style: text_pink_20(),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.grey[700]),
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
        .collection('공지사항')
        .where('출력', isEqualTo: 'Y')
        .snapshots(),
    builder: (context, snapshot) {
    if (!snapshot.hasData)
    return Center(child: CircularProgressIndicator());
    return _buildList(context, snapshot.data.documents);
    },
    ),
    );
  }
}
Widget _buildList(
    BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    padding: const EdgeInsets.only(bottom: 20.0),
    children: snapshot
        .map((data) => _buildListItem(context, data))
        .toList(),
  );
}

Widget _buildListItem(
    BuildContext context, DocumentSnapshot data) {
  final record = Record.fromSnapshot(data);

  return
     Padding(
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
                      record.title,
                      style: text_darkgrey_20(),
                    ),
                    Text(
                      record.date,
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
                    Text(record.content,
                        style: text_darkgrey_15()),
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
  final String date;
  final String title;
  final String content;

  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['날짜'] != null),
        assert(map['내용'] != null),
        assert(map['제목'] != null),
        date = map['날짜'],
        content = map['내용'],
        title = map['제목']
        ;

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() =>
      "Record<$date:$content:$title>";
}
