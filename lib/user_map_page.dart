import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'settings/styles.dart';
import 'user_chat_page.dart';

enum menus {
  submenu1,
  submenu2,
  submenu3,
  submenu4,
  submenu5,
  submenu6,
  submenu7
} //우측상단 팝업버튼

class User_Map_Page extends StatefulWidget {
  @override
  _User_Map_PageState createState() => _User_Map_PageState();
}

class _User_Map_PageState extends State<User_Map_Page> {

  GoogleMapController _googleMapController;

  Position position;

  Widget _child;

  @override
  void initState() {
    _child = Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _googleMapController = controller;
          },
          initialCameraPosition: CameraPosition(
            target: LatLng(37.543606, 127.078558),
            zoom: 17.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('현재 위치를 가져오고 있어요', style: text_grey_15(),),
            Container(
              height: 30,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ],
    );
    _getCurrentLocation();
//    setCustomMapPin();
    super.initState();
  }

  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });
  }

  Widget mapWidget() {
    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _googleMapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 17.0,
      ),
      markers: _createMarker(),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('park1'),
        position: LatLng(37.546360, 127.067886),
        icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Chatstart(context);
          }
      ),
      Marker(
        markerId: MarkerId('park2'),
        position: LatLng(37.544397, 127.070600),
        icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Chatstart(context);
          }
      ),
      Marker(
        markerId: MarkerId('park3'),
        position: LatLng(37.546500, 127.071796),
        icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Chatstart(context);
          }
      ),
      Marker(
        markerId: MarkerId('park4'),
        position: LatLng(37.542682, 127.066887),
        icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Chatstart(context);
          }
      ),
      Marker(
        markerId: MarkerId('park5'),
        position: LatLng(37.541528, 127.069683),
        icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            Chatstart(context);
          }
      ),
    ].toSet();
  }

  BitmapDescriptor pinLocationIcon;

  void setCustomMapPin() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10, 10)), 'images/halfofthing_logo.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'images/halfofthing_logo_white_1024x1024.png',
                height: 40,
              ),
              Container(
                width: 10,
              ),
              Text(
                '반띵',
                style: text_white_20(),
              ),
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            PopupMenuButton<menus>(
              icon: Icon(Icons.list),
              onSelected: (menus result) {
                if (result == menus.submenu1) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu1()));
                } else if (result == menus.submenu2) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu2()));
                } else if (result == menus.submenu3) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
                } else if (result == menus.submenu4) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
                } else if (result == menus.submenu5) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
                } else if (result == menus.submenu6) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
                } else if (result == menus.submenu7) {
//                  Navigator.of(context)
//                      .push(MaterialPageRoute(builder: (context) => Submenu3()));
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<menus>>[
                PopupMenuItem<menus>(
                  value: menus.submenu1,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '내 정보',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '이용기록',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu3,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.library_books,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '이용방법',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu4,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.notifications,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '공지사항',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu5,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.warning,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '신고하기',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.help_outline,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '고객지원',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<menus>(
                  value: menus.submenu7,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.settings,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(
                        '설정',
                        style: TextStyle(color: Colors.grey),
                        textScaleFactor: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(children: <Widget>[
          Center(child: _child),
          GestureDetector(
            onTap: () {
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Center(
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40)),
                        elevation: 5,
                        color: Colors.green,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: Center(
                                child: Text(
                              '반띵 시작하기',
                              style: text_white_20(),
                            )),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ]));
  }
}

Widget Chatstart(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '메뉴 :',
                    style: TextStyle(color: Colors.brown),
                    textScaleFactor: 1,
                  ),
                  Container(
                    width: 10,
                  ),
                ],
              ),
              Container(
                height: 40,
              ),
              Text(
                '반띵을 시작하시겠습니까?',
                style: TextStyle(color: Colors.brown),
                textScaleFactor: 1,
              ),
              Container(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '취소',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => User_Chat_Page()));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 5,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        child: Center(
                          child: Text(
                            '확인',
                            style: TextStyle(color: Colors.brown),
                            textScaleFactor: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      });
}
