import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/user.dart';
import '../reducer/combineRecuder.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, User>(
        converter: (store) =>
            store.state.user.init ? store.state.user : User.create(store),
        builder: (context, user) {
          var leftRightPadding = 30.0;
          var topBottomPadding = 4.0;
          var hintTips = new TextStyle(fontSize: 15.0, color: Colors.black26);
          var _userCodeController = new TextEditingController();
          _userCodeController.text = user.userCode;
          return new Scaffold(
              appBar: new AppBar(
                title:
                    new Text("登录", style: new TextStyle(color: Colors.white)),
                iconTheme: new IconThemeData(color: Colors.white),
              ),
              body: new Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(leftRightPadding, 50.0,
                        leftRightPadding, topBottomPadding),
                    child: new TextField(
                      style: hintTips,
                      controller: _userCodeController,
                      decoration: new InputDecoration(hintText: "请输入用户码"),
                      obscureText: false,
                    ),
                  ),
                  new Container(
                    width: 360.0,
                    margin: new EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
                    padding: new EdgeInsets.fromLTRB(leftRightPadding,
                        topBottomPadding, leftRightPadding, topBottomPadding),
                    child: new Card(
                      color: Colors.green,
                      elevation: 6.0,
                      child: new FlatButton(
                          onPressed: () {
                            if (_userCodeController.text == '') {
                              return false;
                            }
                            print("用户码：" + _userCodeController.text);
                            user.setUserCode(_userCodeController.text);
                            Navigator.of(context).pushNamed('/nav');
                          },
                          child: new Padding(
                            padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              '登录',
                              style: new TextStyle(
                                  color: Colors.white, fontSize: 16.0),
                            ),
                          )),
                    ),
                  )
                ],
              ));
        });
  }
}
