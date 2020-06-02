import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:halfofthing/settings/styles.dart';
import 'package:search_widget/search_widget.dart';

import 'user_main_page.dart';

class Select_Region_Page extends StatefulWidget {
  @override
  _Select_Region_PageState createState() => _Select_Region_PageState();
}

class _Select_Region_PageState extends State<Select_Region_Page> {
  List<LeaderBoard> list = <LeaderBoard>[
    LeaderBoard('가톨릭학교'),
    LeaderBoard('건국대학교'),
    LeaderBoard('경기대학교'),
    LeaderBoard('경희대학교'),
    LeaderBoard('고려대학교'),
    LeaderBoard('광운대학교'),
    LeaderBoard('국민대학교'),
    LeaderBoard('동국대학교'),
    LeaderBoard('명지대학교'),
    LeaderBoard('삼육대학교'),
    LeaderBoard('상명대학교'),
    LeaderBoard('서강대학교'),
    LeaderBoard('서경대학교'),
    LeaderBoard('서울대학교 관악캠퍼스'),
    LeaderBoard('서울대학교 연건캠퍼스'),
    LeaderBoard('서울과학기술대학교'),
    LeaderBoard('서울시립대학교'),
    LeaderBoard('성균관대학교'),
    LeaderBoard('세종대학교'),
    LeaderBoard('숭실대학교'),
    LeaderBoard('연세대학교'),
    LeaderBoard('중앙대학교'),
    LeaderBoard('한국외국어대학교'),
    LeaderBoard('한성대학교'),
    LeaderBoard('한양대학교'),
    LeaderBoard('홍익대학교'),


  ];

  LeaderBoard _selectedItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '학교를 선택해주세요',
            style: text_grey_15(),
          ),
          Container(
            height: 30,
          ),
          SearchWidget<LeaderBoard>(
            dataList: list,
            hideSearchBoxWhenItemSelected: true,
            listContainerHeight: MediaQuery.of(context).size.height / 2,
            queryBuilder: (query, list) {
              return list
                  .where((item) => item.username
                      .toLowerCase()
                      .contains(query.toLowerCase()))
                  .toList();
            },
            popupListItemBuilder: (item) {
              return PopupListItemWidget(item);
            },
            selectedItemBuilder: (selectedItem, deleteSelectedItem) {
              return SelectedItemWidget(selectedItem, deleteSelectedItem);
            },
            // widget customization
            noItemsFoundWidget: NoItemsFound(),
            textFieldBuilder: (controller, focusNode) {
              return MyTextField(controller, focusNode);
            },
            onItemSelected: (item) {
              setState(() {
                _selectedItem = item;
              });
            },
          ),
          Container(
            height: 30,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => User_Main_Page()));
            },
            child: FittedBox(
              fit: BoxFit.contain,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 15,
                color: Colors.pink,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 35, right: 35, top: 15, bottom: 15),
                  child: Center(
                      child: Text(
                    '확인',
                    style: text_white_20(),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderBoard {
  LeaderBoard(this.username);

  final String username;
}

class SelectedItemWidget extends StatelessWidget {
  const SelectedItemWidget(this.selectedItem, this.deleteSelectedItem);

  final LeaderBoard selectedItem;
  final VoidCallback deleteSelectedItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
        horizontal: 4,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Text(
                selectedItem.username,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22),
            color: Colors.grey[700],
            onPressed: deleteSelectedItem,
          ),
        ],
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField(this.controller, this.focusNode);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        showCursor: true,
        cursorColor: Colors.pink,
        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0x4437474F),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          suffixIcon: Icon(Icons.search),
          border: InputBorder.none,
//          hintText: "반띵대학교...",
          contentPadding: const EdgeInsets.only(
            left: 16,
            right: 20,
            top: 14,
            bottom: 14,
          ),
        ),
      ),
    );
  }
}

class NoItemsFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.folder_open,
          size: 24,
          color: Colors.grey[900].withOpacity(0.7),
        ),
        const SizedBox(width: 10),
        Text(
          '검색 결과가 없어요',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[900].withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

class PopupListItemWidget extends StatelessWidget {
  const PopupListItemWidget(this.item);

  final LeaderBoard item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        item.username,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
