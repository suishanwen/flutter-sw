import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sw/action/socketAction.dart';
import 'package:sw/app/animate/heart.dart';
import 'package:sw/app/animate/dlProgress.dart';
import 'package:sw/model/dataset/controller.dart';
import '../../model/onlineCtrl.dart';
import '../../model/appState.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'control.dart';

class OnlineList extends StatefulWidget {
  final String userCode;

  OnlineList(this.userCode);

  @override
  _OnlineListState createState() => new _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  Map<String, WebSocketChannel> channelMap =
      new Map<String, WebSocketChannel>();

  Map<String, Heart> heartMap = new Map<String, Heart>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnlineCtrl>(converter: (store) {
      OnlineCtrl onlineCtrl;
      if (!store.state.onlineCtrl.init) {
        onlineCtrl = OnlineCtrl.create(store);
        onlineCtrl.loadCtrlList(widget.userCode, true);
      } else {
        onlineCtrl = store.state.onlineCtrl;
      }
      return onlineCtrl;
    }, builder: (context, onlineCtrl) {
      List<Controller> ctrlList = onlineCtrl.ctrlList;
      ctrlList.forEach((f) {
        channelMap.putIfAbsent(
            "${f.identity}_mobi",
            () => new IOWebSocketChannel.connect(
                'ws://bitcoinrobot.cn:8051/sw/api/websocket/${f.identity}_mobi'));
        heartMap.putIfAbsent("${f.identity}_mobi", () => new Heart());
      });
      return Scaffold(
        body: new Stack(children: [
          Container(
            child: ListView.builder(
                itemCount: ctrlList.length,
                itemBuilder: (BuildContext content, int index) {
                  Controller ctrl = ctrlList[index];
                  Heart heart = heartMap["${ctrl.identity}_mobi"];
                  WebSocketChannel channel =
                      channelMap["${ctrl.identity}_mobi"];
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    // 根据设置裁剪内容
                    color: Colors.green,
                    //  卡片背景颜色
                    elevation: 20.0,
                    // 卡片的z坐标,控制卡片下面的阴影大小
                    margin: EdgeInsets.all(20.0),
                    //  margin: EdgeInsetsDirectional.only(bottom: 30.0, top: 30.0, start: 30.0),// 边距
                    semanticContainer: true,
                    // 表示单个语义容器，还是false表示单个语义节点的集合，接受单个child，但该child可以是Row，Column或其他包含子级列表的widget
//      shape: Border.all(
//          color: Colors.indigo, width: 1.0, style: BorderStyle.solid), // 卡片材质的形状，以及边框
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    // 圆角
                    //borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    child: Column(
                      //card里面的子控件
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Align(
                            alignment: new FractionalOffset(1.0, 0.0),
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Transform.rotate(
                                  angle: 1.0,
                                  child: Text(
                                    '${ctrl.autoVote == 1 ? "自动" : "人工"}',
                                    style: TextStyle(
                                        color: Colors.lightGreenAccent),
                                  ),
                                ))),
                        ListTile(
                          leading: Column(
                              //card里面的子控件
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child: Text(ctrl.sort.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                                  margin: EdgeInsets.all(5.0),
                                ),
                                Container(
                                  child: Text(ctrl.uname,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      )),
                                  margin: EdgeInsets.all(5.0),
                                )
                              ]),
                          title: Text(
                              '${ctrl.workerId} ${ctrl.startNum}-${ctrl.endNum}',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 40.0)),
                          subtitle: Container(
                            child: StreamBuilder(
                              stream: channel.stream,
                              builder: (context, snapshot) {
                                Map<String, String> map =
                                    new Map<String, String>();
                                if (snapshot.hasData) {
                                  var data = snapshot.data.toString();
                                  if (data == SocketAction.REFRESH_PROTECT) {
                                  } else if (mounted &&
                                      data == SocketAction.REFRESH_STATE) {
                                    new Future.delayed(
                                        const Duration(seconds: 1), () {
                                      onlineCtrl.loadCtrlList(
                                          widget.userCode, false);
                                    });
                                  } else {
                                    data.split("&").forEach((f) {
                                      List<String> arr = f.split("=");
                                      map.putIfAbsent(arr[0],
                                          () => arr.length == 2 ? arr[1] : "");
                                    });
                                  }
                                  heart.beat();
                                }
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //card里面的子控件
                                    children: <Widget>[
                                      Text(
                                        "掉线:${map["arrDrop"]}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "活跃:${map["arrActive"]}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20),
                                      ),
                                      Text(
                                        "任务信息\n${map["taskInfos"]}",
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 20),
                                      ),
                                    ]);
                              },
                            ),
                          ),
                          contentPadding: EdgeInsets.all(20.0), // item 内容内边距
                        ),
                        ButtonTheme.bar(
                          // make buttons use the appropriate styles for cards
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: heart,
                                onPressed: () {},
                              ),
                              FlatButton(
                                child: new DlProgress(ctrl.identity,
                                    SocketAction.REPORT_STATE_LESS),
                                onPressed: () {},
                              ),
                              FlatButton(
                                child: new Icon(
                                  Icons.mobile_screen_share,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.push<String>(context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return new Control(ctrl);
                                  })).then((val) {
                                    Navigator.of(context).pushReplacementNamed('/nav');
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ]),
        floatingActionButton: new FloatingActionButton(
          tooltip: '刷新',
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.grey,
          onPressed: () {
            onlineCtrl.loadCtrlList(widget.userCode, true);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    channelMap.forEach((key, channel) {
      print("channer ${key} close");
      channel.sink.close();
    });
    super.dispose();
  }
}
