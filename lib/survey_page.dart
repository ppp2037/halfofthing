import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'background_page.dart';
import 'package:halfofthing/user_chat_page.dart';
import 'settings/styles.dart';

class Survey_Page extends StatefulWidget {
  final AsyncSnapshot snapshot_board;
  final bool userIsHost;
  Survey_Page(
      {Key key, @required this.snapshot_board, @required this.userIsHost})
      : super(key: key);
  @override
  _Survey_PageState createState() => _Survey_PageState();
}

class _Survey_PageState extends State<Survey_Page> {
  final GlobalKey<FormState> _feedbackFormKey =
  GlobalKey<FormState>();
  final TextEditingController _feedbackController =
  TextEditingController();
  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  String _feedback;
  String _userPhoneNumber;
  String _userLocation;

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

  int _selectedDoneWell = 0;
  List<String> _doneWell = ['미선택', '네', '아니오'];
  double _value = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('설문', style: text_pink_20(),),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.grey[700]),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  '잘 반띵 했나요?',
                  style: text_darkgrey_20(),
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => _selectedDoneWell = 1),
                      onLongPress: () => setState(() => _selectedDoneWell = 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        elevation: 5,
                        color:
                        _selectedDoneWell == 1 ? Colors.pink : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 15, bottom: 15),
                          child: Center(
                              child: Text(
                                _doneWell[1],
                                style: (TextStyle(
                                    color: _selectedDoneWell == 1
                                        ? Colors.white
                                        : Colors.grey[700])),
                                textScaleFactor: 1.0,
                              )),
                        ),
                      ),
                    ),
                    Container(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _selectedDoneWell = 2),
                      onLongPress: () => setState(() => _selectedDoneWell = 0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60)),
                        elevation: 5,
                        color:
                        _selectedDoneWell == 2 ? Colors.pink : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 15, bottom: 15),
                          child: Center(
                              child: Text(
                                _doneWell[2],
                                style: (TextStyle(
                                    color: _selectedDoneWell == 2
                                        ? Colors.white
                                        : Colors.grey[700])),
                                textScaleFactor: 1.0,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Text(
                  '반띵 서비스에 얼마나 만족하시나요?',
                  style: text_darkgrey_20(),
                ),
                Container(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.pink,
                      inactiveTrackColor: Colors.grey,
                      trackShape: RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.pink,
                      overlayColor: Colors.red.withAlpha(32),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.white,
                      inactiveTickMarkColor: Colors.white,
                      valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.pink,
                      valueIndicatorTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: 100,
                      divisions: 5,
                      label: '$_value',
                      value: _value,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 6,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 15,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                        child: Form(
                          key: _feedbackFormKey,
                          child: TextFormField(
                            style: text_darkgrey_15(),
                            onChanged: (String str) {
                              setState(() {
                                _feedback = str;
                              });
                            },
                            keyboardType: TextInputType.text,
                            maxLines: null,
                            controller: _feedbackController,
                            decoration: InputDecoration(
                                hintText: '(선택) 반띵의 개선사항이 있으면 알려주세요',
                                hintStyle: text_grey_15(),
                                icon: Icon(Icons.edit, color: Colors.grey[700],),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    var _currentTime = DateTime.now();
                    var _userOrderId =
                    DateFormat('yyyyMMddHHmmss').format(_currentTime);
                    Firestore.instance
                        .collection('survey')
                        .document(_userPhoneNumber + '_' + _userOrderId)
                        .setData({
                      'feedback': _feedback ?? '',
                      'completed': _doneWell[_selectedDoneWell],
                      'rating': _value,
                      'university': _userLocation,
                      'userID': _userPhoneNumber,
                      'feedbackId': _userPhoneNumber + '_' + _userOrderId,
                    });
                    if (widget.userIsHost) {
                      widget.snapshot_board.data.reference
                          .updateData({'hostComplete': true});
                    } else {
                      widget.snapshot_board.data.reference
                          .updateData({'guestComplete': true});
                    }
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: Card(
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60)),
                      elevation: 15,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Container(
                            height: 50,
                            child: Center(
                                child: Text(
                                  '완료',
                                  style: text_white_20(),
                                ))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}