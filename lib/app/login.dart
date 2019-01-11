import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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
          var hintTips = new TextStyle(fontSize: 20.0, color: Colors.black26);
          var _userCodeController = new TextEditingController.fromValue(
              TextEditingValue(
                  text: user.userCode,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: user.userCode.length))));
          return new Scaffold(
              appBar: new AppBar(
                title:
                    new Text("用户码", style: new TextStyle(color: Colors.white)),
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
                      autofocus: true,
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
                              showDialog(
                                context: context,
                                builder: (_) => PlatformAlertDialog(
                                      title: Text('提示'),
                                      content: Text('用户码不能为空！'),
                                      actions: <Widget>[
                                        PlatformDialogAction(
                                          child: PlatformText('确定'),
                                          onPressed: () => Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop('dialog'),
                                        )
                                      ],
                                    ),
                              );
                              return;
                            }
                            print("用户码：" + _userCodeController.text);
                            user.setUserCode(_userCodeController.text);
                            Navigator.of(context).pushReplacementNamed('/nav');
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
