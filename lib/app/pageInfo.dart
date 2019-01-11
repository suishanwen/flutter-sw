import 'package:flutter/material.dart';
import 'cardList.dart';

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
        return new CardList(userCode);
        break;
      case 1:
        data = "用户：${userCode} 在线";
        break;
      case 2:
        data = "用户：${userCode} 日志";
        break;
    }
    return new Text(data);
  }
}
