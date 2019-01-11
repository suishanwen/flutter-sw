import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/page.dart';
import '../model/user.dart';
import '../reducer/combineRecuder.dart';
import 'pageInfo.dart';

class IconInfo {
  int page;
  String title;
  IconData icon;

  IconInfo(this.page, this.title, this.icon);
}

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

      Color getColor(index) {
        return page.pageIndex == index ? Colors.orange : Colors.grey;
      }

      void setPageIndex(index) {
        page.setPageIndex(index);
      }

      List<BottomNavigationBarItem> generateBottomNavigationBarItems(
          List<IconInfo> iconInfoList) {
        return iconInfoList.map((IconInfo item) {
          return BottomNavigationBarItem(
            icon: Icon(
              item.icon,
              color: getColor(item.page),
              size: 30,
            ),
            title: Text(item.title,
                style: TextStyle(
                    fontSize: 15.0,
                    color: getColor(item.page),
                    decoration: TextDecoration.none)),
          );
        }).toList();
      }

      return new Scaffold(
        appBar: new AppBar(
          actions: <Widget>[],
        ),
        body: new PageInfo(page.pageIndex, user.userCode),
        bottomNavigationBar: new BottomNavigationBar(
          items: generateBottomNavigationBarItems([
            new IconInfo(0, "卡片", Icons.sim_card),
            new IconInfo(1, "在线", Icons.cloud_circle),
            new IconInfo(2, "日志", Icons.description),
          ]),
          onTap: setPageIndex,
        ),
      );
    });
  }
}
