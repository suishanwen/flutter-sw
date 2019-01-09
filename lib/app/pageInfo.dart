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
        data = "用户：${userCode} 首页";
        break;
      case 1:
        data = "用户：${userCode} 添加页";
        break;
      case 2:
        return new CardList(userCode);
        break;
      case 3:
        data = "用户：${userCode} 项目页";
        break;
      case 4:
        data = "用户：${userCode} 下载页";
        break;
      case 5:
        data = "用户：${userCode} 在线页";
        break;
      case 6:
        data = "用户：${userCode} 日志页";
        break;
    }
    return new Text(data);
  }
}
