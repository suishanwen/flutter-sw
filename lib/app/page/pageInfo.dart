import 'package:flutter/material.dart';
import 'package:sw/app/page/cardList.dart';
import 'package:sw/app/page/onlineList.dart';
import 'package:sw/app/page/log.dart';

class PageInfo extends StatefulWidget {
  final int page;
  final String userCode;

  PageInfo(this.page, this.userCode);

  @override
  _PageState createState() => new _PageState();
}

class _PageState extends State<PageInfo> {
  @override
  Widget build(BuildContext context) {
    int page = widget.page;
    String userCode = widget.userCode;
    String data = "";
    switch (page) {
      case 0:
        return CardList(userCode);
        break;
      case 1:
        return OnlineList(userCode);
        break;
      case 2:
        return Log();
        break;
    }
    return new Text(data);
  }
}
