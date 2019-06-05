import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sw/action/socketAction.dart';
import 'package:sw/app/animate/heart.dart';
import 'package:sw/app/animate/dlProgress.dart';
import 'package:sw/model/dataset/controller.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'control.dart';

Dio dio = new Dio();

class OnlineList extends StatefulWidget {
  final String userCode;

  OnlineList(this.userCode);

  @override
  _OnlineListState createState() => new _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  String userCode;

  RefreshController _refreshController;

  List<Controller> ctrlList;

  Map<String, WebSocketChannel> channelMap =
      new Map<String, WebSocketChannel>();

  Map<String, Heart> heartMap = new Map<String, Heart>();

  @override
  initState() {
    super.initState();
    userCode = widget.userCode;
    ctrlList = new List<Controller>();
    // initialRefresh可以在组件初始化时执行一次刷新操作
    _refreshController = RefreshController(initialRefresh: false);
    queryController((status, ctrlList) {
      socketConnect((channelMap) {
        if (mounted) {
          setState(() {
            ctrlList = ctrlList;
            channelMap = channelMap;
          });
        }
      });
    });
  }

  void queryController(Function callback) async {
    ctrlList = new List<Controller>();
    try {
      var response = await dio
          .post("https://bitcoinrobot.cn/api/vote/queryList", data: userCode);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        data.forEach((f) {
          Controller ctrl =
              new Controller.fromJson(json.decode(json.encode(f)));
          ctrlList.add(ctrl);
          heartMap.putIfAbsent("${ctrl.identity}_mobi", () => new Heart());
        });
      }
      callback(true, ctrlList);
    } catch (e) {
      callback(false, ctrlList);
      print("queryList Error:" + e.toString());
    }
  }

  void socketConnect(callback) {
    ctrlList.forEach((ctrl) {
      channelMap["${ctrl.identity}_mobi"] = IOWebSocketChannel.connect(
          'ws://bitcoinrobot.cn:8051/sw/api/websocket/${ctrl.identity}_mobi');
    });
    new Future.delayed(const Duration(seconds: 1), () {
      ctrlList.forEach((ctrl) {
        dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl", data: {
          "code": SocketAction.REPORT_STATE_DB,
          "identity": ctrl.identity
        });
      });
    });
    callback(channelMap);
  }

  void _onRefresh() {
    if (mounted) {
      queryController((status, ctrlList) {
        if (status) {
          setState(() {
            ctrlList = ctrlList;
          });
          _refreshController.refreshCompleted();
        } else {
          _refreshController.refreshFailed();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(children: [
        Container(
            child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: defaultTargetPlatform == TargetPlatform.iOS
              ? WaterDropHeader()
              : WaterDropMaterialHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
              itemCount: ctrlList.length,
              itemBuilder: (BuildContext content, int index) {
                Controller ctrl = ctrlList[index];
                Heart heart = heartMap["${ctrl.identity}_mobi"];
                WebSocketChannel channel = channelMap["${ctrl.identity}_mobi"];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.green,
                  elevation: 20.0,
                  margin: EdgeInsets.all(20.0),
                  semanticContainer: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Column(
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
                                  style:
                                      TextStyle(color: Colors.lightGreenAccent),
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
                            style:
                                TextStyle(color: Colors.white, fontSize: 40.0)),
                        subtitle: Container(
                          child: StreamBuilder(
                            stream: channel.stream,
                            builder: (context, snapshot) {
                              Map<String, String> map =
                                  new Map<String, String>();
                              if (snapshot.hasData) {
                                var data = snapshot.data.toString();
                                if (mounted &&
                                    data == SocketAction.REFRESH_STATE) {
                                  new Future.delayed(const Duration(seconds: 0),
                                      () {
                                    _refreshController.requestRefresh();
                                  });
                                } else if (mounted &&
                                    data.contains("arrDrop")) {
                                  data.split("&").forEach((f) {
                                    List<String> arr = f.split("=");
                                    map.putIfAbsent(arr[0],
                                        () => arr.length == 2 ? arr[1] : "");
                                  });
                                  heart.beat();
                                }
                              }
                              map["arrDrop"] =
                                  map["arrDrop"] != null ? map["arrDrop"] : "";
                              map["arrActive"] = map["arrActive"] != null
                                  ? map["arrActive"]
                                  : "";
                              map["taskInfos"] = map["taskInfos"] != null
                                  ? map["taskInfos"]
                                  : "无";
                              return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //card里面的子控件
                                  children: <Widget>[
                                    Text(
                                      "掉线:${map["arrDrop"]}",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                    Text(
                                      "活跃:${map["arrActive"]}",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
                                    ),
                                    Text(
                                      "任务信息\n${map["taskInfos"]}",
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 20),
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
                                  new Future.delayed(const Duration(seconds: 2),
                                      () {
                                    socketConnect((channelMap) {
                                      if (mounted) {
                                        setState(() {
                                          channelMap = channelMap;
                                        });
                                      }
                                    });
                                  });
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
        )),
      ]),
    );
  }

  @override
  void dispose() {
    channelMap.forEach((key, channel) {
      print("channer ${key} close");
      channel.sink.close();
    });
    _refreshController.dispose();
    super.dispose();
  }
}
