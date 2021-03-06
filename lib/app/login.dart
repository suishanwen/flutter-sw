import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../model/user.dart';
import '../model/appState.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return new StoreConnector<AppState, User>(
        converter: (store) =>
            store.state.user.init ? store.state.user : User.create(store),
        builder: (context, user) {
          void login() {
            if (user.userCode == '') {
              showDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                      title: Text('提示'),
                      content: Text('用户码不能为空！'),
                      actions: <Widget>[
                        PlatformDialogAction(
                          child: PlatformText('确定'),
                          onPressed: () =>
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog'),
                        )
                      ],
                    ),
              );
              return;
            }
            print("用户码：" + user.userCode);
            user.login(user.userCode);
            Navigator.of(context).pushReplacementNamed('/nav');
          }

          if (user.init && user.userCode != '' && !user.autoLogin) {
            new Future.delayed(const Duration(seconds: 0), () {
              login();
            });
          }
          var hintTips = new TextStyle(fontSize: 20.0, color: Colors.black);
          var _userCodeController = new TextEditingController.fromValue(
              TextEditingValue(
                  text: user.userCode,
                  // 保持光标在最后
                  selection: TextSelection.fromPosition(TextPosition(
                      affinity: TextAffinity.downstream,
                      offset: user.userCode.length))));
          return new Scaffold(
              appBar: PreferredSize(
                  child: new AppBar(
                    title: new Text("用户登陆",
                        style: new TextStyle(color: Colors.black)),
                    iconTheme: new IconThemeData(color: Colors.white),
                  ),
                  preferredSize: Size.fromHeight(screenHeight * 0.05)),
              body: new Container(
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage('images/login_back.jpg'),
                        fit: BoxFit.fill),
                  ),
                  height: screenHeight * 0.9,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(top: 30),
                        child: new FlutterLogo(
                          size: 80.0,
                          colors: Colors.yellow,
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.fromLTRB(120, 15.0, 120, 4),
                        child: new TextField(
                          style: hintTips,
                          controller: _userCodeController,
                          decoration: new InputDecoration(
                              hintText: "请输入用户码", hintStyle: hintTips),
                          obscureText: false,
                          textAlign: TextAlign.center,
                          onChanged: (val) {
                            user.setUserCode(val);
                          },
                        ),
                      ),
                      new Container(
                          width: 360.0,
                          margin:
                              new EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
                          padding: new EdgeInsets.fromLTRB(100, 4, 100, 4),
                          child: new FlatButton(
                              padding: new EdgeInsets.all(20),
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: Colors.grey,
                                      style: BorderStyle.solid,
                                      width: 1)),
                              onPressed: () {
                                login();
                              },
                              child: new Text(
                                '登录',
                                style: new TextStyle(
                                    color: Colors.grey, fontSize: 18.0),
                              ))),
                    ],
                  )));
        });
  }
}
