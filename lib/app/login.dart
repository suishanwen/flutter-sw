import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../model/user.dart';
import '../reducer/combineRecuder.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return new StoreConnector<AppState, User>(
        converter: (store) =>
            store.state.user.init ? store.state.user : User.create(store),
        builder: (context, user) {
          var hintTips = new TextStyle(fontSize: 20.0, color: Colors.white);
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
                        style: new TextStyle(color: Colors.white)),
                    iconTheme: new IconThemeData(color: Colors.white),
                  ),
                  preferredSize: Size.fromHeight(screenHeight * 0.05)),
              body:new Container(
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
                            padding:
                                new EdgeInsets.fromLTRB(120, 15.0, 120, 4),
                            child: new TextField(
                              style: hintTips,
                              controller: _userCodeController,
                              decoration: new InputDecoration(
                                  hintText: "请输入用户码", hintStyle: hintTips),
                              obscureText: false,
                              autofocus: true,
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
                                                  onPressed: () => Navigator.of(
                                                          context,
                                                          rootNavigator: true)
                                                      .pop('dialog'),
                                                )
                                              ],
                                            ),
                                      );
                                      return;
                                    }
                                    print("用户码：" + _userCodeController.text);
                                    user.login(_userCodeController.text);
                                    Navigator.of(context)
                                        .pushReplacementNamed('/nav');
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
                      )));
        });
  }
}
