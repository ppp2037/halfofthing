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
  GlobalKey<FormState>(); //글로벌 키 => 핸드폰번호 폼 키 생성
  final TextEditingController _feedbackController =
  TextEditingController(); //컨트롤러 생성
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
    return Scaffold(
      appBar: AppBar(
        title: Text('설문'),
        centerTitle: true,
        brightness: Brightness.light,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(
                '잘 반띵 했나요?',
                style: text_grey_20(),
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
                          borderRadius: BorderRadius.circular(20)),
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
                                      : Colors.grey)),
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
                          borderRadius: BorderRadius.circular(20)),
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
                                      : Colors.grey)),
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
                style: text_grey_20(),
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
                          onChanged: (String str) {
                            setState(() {
                              _feedback = str;
                            });
                          },
                          keyboardType: TextInputType.text,
                          maxLines: null,
                          controller: _feedbackController,
                          decoration: InputDecoration(
                              hintText: '반띵의 개선사항이 있으면 알려주세요',
                              hintStyle: text_grey_15(),
                              icon: Icon(Icons.edit),
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
                      .collection('설문조사')
                      .document(_userPhoneNumber + '_' + _userOrderId)
                      .setData({
                    '피드백': _feedback ?? '',
                    '잘반띵여부': _doneWell[_selectedDoneWell],
                    '만족도': _value,
                    '위치': _userLocation,
                    '사용자핸드폰번호': _userPhoneNumber,
                    '피드백이름': _userPhoneNumber + '_' + _userOrderId,
                  });
                  Fluttertoast.showToast(
                      msg: '설문에 답해주셔서 감사합니다',
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.pink,
                      textColor: Colors.white);
                  if (widget.userIsHost) {
                    widget.snapshot_board.data.reference
                        .updateData({'반띵완료_개설자': true});
                  } else {
                    widget.snapshot_board.data.reference
                        .updateData({'반띵완료_참가자': true});
                  }
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Card(
                    color: Colors.pink,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
    );
  }
}