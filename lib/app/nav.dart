import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/page.dart';
import '../model/user.dart';
import '../reducer/combineRecuder.dart';
import 'pageInfo.dart';

class Nav extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppState>(converter: (store) {
      if (!store.state.page.init) {
        Page.create(store);
      }
      return store.state;
    }, builder: (context, appState) {
      Page page = appState.page;
      User user = appState.user;
      return new Scaffold(
          appBar: new AppBar(
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.home),
                tooltip: '首页',
                onPressed: () {
                  page.setPageIndex(0);
                },
                color: page.pageIndex == 0 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.add),
                tooltip: '添加',
                onPressed: () {
                  page.setPageIndex(1);
                },
                color: page.pageIndex == 1 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.sim_card),
                tooltip: '卡片',
                onPressed: () {
                  page.setPageIndex(2);
                },
                color: page.pageIndex == 2 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.library_books),
                tooltip: '项目',
                onPressed: () {
                  page.setPageIndex(3);
                },
                color: page.pageIndex == 3 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.cloud_download),
                tooltip: '下载',
                onPressed: () {
                  page.setPageIndex(4);
                },
                color: page.pageIndex == 4 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.cloud_circle),
                tooltip: '在线',
                onPressed: () {
                  page.setPageIndex(5);
                },
                color: page.pageIndex == 5 ? Colors.white : Colors.black,
              ),
              new IconButton(
                icon: new Icon(Icons.description),
                tooltip: '日志',
                onPressed: () {
                  page.setPageIndex(6);
                },
                color: page.pageIndex == 6 ? Colors.white : Colors.black,
              ),
            ],
          ),
          body: new PageInfo(page.pageIndex, user.userCode));
    });
  }
}
