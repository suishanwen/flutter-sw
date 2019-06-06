import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:sw/action/socketAction.dart';
import 'package:sw/app/animate/dlProgress.dart';
import 'package:sw/app/animate/heart.dart';
import 'package:sw/model/dataset/controller.dart';
import 'package:sw/model/dataset/voteProject.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Dio dio = new Dio();

class Control extends StatefulWidget {
  final Controller ctrl;

  Control(this.ctrl);

  @override
  _ControlPage createState() => new _ControlPage();
}

class _ControlPage extends State<Control> {
  Controller ctrl;
  List<VoteProject> projectList = new List<VoteProject>();
  Heart heart = new Heart();
  WebSocketChannel channel;
  String replugSort = "";
  RefreshController _refreshController;
  int beatCount = 0;
  double voteViewTop = 400;

  @override
  void initState() {
    super.initState();
    ctrl = widget.ctrl;
    channel = new IOWebSocketChannel.connect(
        'ws://bitcoinrobot.cn:8051/sw/api/websocket/${ctrl.identity}_mobi');
    reportState();
    channel.stream.listen((data) {
      if (data.contains("startNum=")) {
        getCtrlInfo(data);
      } else if (data.contains("votes=")) {
        List<String> voteList = data.split("=")[1].split(",");
        if (mounted && voteList.length > 0) {
          new Future.delayed(const Duration(seconds: 1), () {
            showDialog<Null>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: new Text('投票'),
                  content: Container(
                    width: 500,
                    height: 800,
                    child: ListView.builder(
                        itemCount: voteList.length,
                        itemBuilder: (BuildContext content, int index) {
                          String project = voteList[index];
                          return Card(
                              clipBehavior: Clip.antiAlias,
                              color: Colors.green,
                              margin: EdgeInsets.all(10.0),
                              child: GestureDetector(
                                  child: Text(
                                    project,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 22),
                                  ),
                                  onLongPress: () {
                                    if (project != "") {
                                      Navigator.of(context).pop();
                                      control(
                                          "${SocketAction.TASK_VOTE_PROJECT}:${project}");
                                    }
                                  }));
                        }),
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('关闭'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          });
        }
      }
    });
    _refreshController = RefreshController(initialRefresh: true);
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _onRefresh() {
    getVoteInfo((status) {
      if (status) {
        if (mounted) {
          setState(() {
            beatCount = 0;
            projectList = projectList;
          });
        }
        _refreshController.refreshCompleted();
      } else {
        _refreshController.refreshFailed();
      }
    });
  }

  void reportState() {
    dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl",
        data: {"code": SocketAction.REPORT_STATE, "identity": ctrl.identity});
  }

  void vote(projectName) {
    dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl", data: {
      "code": "${SocketAction.TASK_VOTE_PROJECT}:${projectName}",
      "identity": ctrl.identity
    });
  }

  getCtrlInfo(data) {
    if (mounted) {
      Map<String, dynamic> map = new Map<String, dynamic>();
      data.split("&").forEach((f) {
        List<String> arr = f.split("=");
        String name = arr[0];
        String val = arr.length == 2 ? arr[1] : "";
        if (name != "workerId" &&
            name != "dropped" &&
            name != "droppedTemp" &&
            name != "topped") {
          map.putIfAbsent(name, () => val != "" ? int.parse(val) : "");
        } else {
          map.putIfAbsent(name, () => val);
        }
      });
      map["uname"] = ctrl.uname;
      map["identity"] = ctrl.identity;
      map["user"] = ctrl.user;
      beatCount++;
      setState(() {
        ctrl = new Controller.fromJson(json.decode(json.encode(map)));
        beatCount = beatCount;
      });
      heart.beat();
      if (beatCount == 20) {
        _refreshController.requestRefresh();
      }
    }
  }

  getVoteInfo(Function callback) async {
    try {
      var response =
          await dio.get("https://tl.bitcoinrobot.cn/voteInfo/?idAdsl=1");
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.data);
        projectList = new List<VoteProject>();
        data.forEach((e) {
          VoteProject voteProject = new VoteProject.fromJson(e);
          projectList.add(voteProject);
        });
        projectList.sort((v1, v2) {
          double d1 = isToppedProject(v1.projectName)
              ? 99999.0
              : double.parse(v1.price);
          double d2 = isToppedProject(v2.projectName)
              ? 99999.0
              : double.parse(v2.price);
          double diff = (d2 - d1) * 1000;
          return diff.toInt();
        });
        callback(true);
      } else {
        callback(false);
      }
    } catch (e) {
      callback(false);
      print("getVoteInfo Error:" + e.toString());
    }
  }

  bool isDroppedProject(String projectName) {
    bool match = false;
    ctrl.dropped.split("|").forEach((name) {
      if (name != "" && projectName.contains(name)) {
        match = true;
      }
    });
    if (!match) {
      ctrl.droppedTemp.split("|").forEach((name) {
        if (name != "" && projectName.contains(name)) {
          match = true;
        }
      });
    }
    return match;
  }

  bool isToppedProject(String projectName) {
    bool match = false;
    ctrl.topped.split("|").forEach((name) {
      if (name != "" && projectName.contains(name)) {
        match = true;
      }
    });
    return match;
  }

  control(String code) {
    if (code.contains("TASK") || code.contains("AUTO_VOTE_INDEX_NAME_START")) {
      showDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
              title: Text('提示'),
              content: Text('确定要执行？\n${code}'),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('取消'),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                ),
                new FlatButton(
                  child: new Text('确定'),
                  onPressed: () {
                    dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl",
                        data: {"code": code, "identity": ctrl.identity});
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                  },
                )
              ],
            ),
      );
    } else {
      dio.post("https://bitcoinrobot.cn/api/mq/send/ctrl",
          data: {"code": code, "identity": ctrl.identity});
    }
  }

  @override
  Widget build(BuildContext context) {
    var vm1Ctrl = new TextEditingController.fromValue(TextEditingValue(
        text: ctrl.startNum.toString(),
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: ctrl.startNum.toString().length))));
    var vm2Ctrl = new TextEditingController.fromValue(TextEditingValue(
        text: ctrl.endNum.toString(),
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: ctrl.endNum.toString().length))));
    var workerCtrl = new TextEditingController.fromValue(TextEditingValue(
        text: ctrl.workerId,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream, offset: ctrl.workerId.length))));
    var timeoutCtrl = new TextEditingController.fromValue(TextEditingValue(
        text: ctrl.timeout.toString(),
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: ctrl.timeout.toString().length))));
    var replugCtrl = new TextEditingController.fromValue(TextEditingValue(
        text: replugSort,
        selection: TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: replugSort.toString().length))));
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(ctrl.uname),
          actions: <Widget>[
            FlatButton(
              child: Icon(voteViewTop == 0
                  ? Icons.border_horizontal
                  : Icons.zoom_out_map),
              onPressed: () {
                setState(() {
                  voteViewTop = voteViewTop == 0 ? 400 : 0;
                });
              },
            ),
            FlatButton(
              child: heart,
              onPressed: () {},
            ),
            FlatButton(
              child: new DlProgress(ctrl.identity, SocketAction.REPORT_STATE),
              onPressed: () {},
            ),
          ],
        ),
        body: new Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 0,
                      height: 20,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: 55,
                      child: Text('虚拟机',
                          style: TextStyle(fontSize: 15.5, height: 1),
                          textAlign: TextAlign.left),
                    ),
                    Container(
                        width: 40,
                        child: TextField(
                            controller: vm1Ctrl,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onChanged: (val) {
                              if (val != "") {
                                control("${SocketAction.FORM1_VM1}:${val}");
                              }
                            })),
                    Container(
                      width: 40,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                      child: Text(' —— ',
                          style: TextStyle(fontSize: 15.5, height: 1),
                          textAlign: TextAlign.left),
                    ),
                    Container(
                        width: 40,
                        child: TextField(
                            controller: vm2Ctrl,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onChanged: (val) {
                              if (val != "") {
                                control("${SocketAction.FORM1_VM2}:${val}");
                              }
                            })),
                    Container(
                        margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                        width: 40,
                        child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onChanged: (val) {
                              control("${SocketAction.FORM1_VM3}:${val}");
                            }))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 55,
                        child: Checkbox(
                            activeColor: Colors.blue,
                            tristate: false,
                            value: ctrl.workerInput == 1,
                            onChanged: (bool val) {
                              if (mounted) {
                                control(SocketAction.FORM1_WORKER_INPUT);
                              }
                            })),
                    Container(
                      width: 40,
                      child: Text('工号',
                          style: TextStyle(fontSize: 15.5, height: 1),
                          textAlign: TextAlign.left),
                    ),
                    Container(
                        width: 120,
                        child: TextField(
                            controller: workerCtrl,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onChanged: (val) {
                              if (val != "") {
                                control(
                                    "${SocketAction.FORM1_WORKER_SET}:${val}");
                              }
                            })),
                    Container(
                        width: 55,
                        child: Checkbox(
                            activeColor: Colors.blue,
                            tristate: false,
                            value: ctrl.tail == 1,
                            onChanged: (bool bol) {
                              if (mounted) {
                                control(SocketAction.FORM1_WORKER_TAIL);
                              }
                            })),
                    Container(
                      width: 40,
                      child: Text('分号',
                          style: TextStyle(fontSize: 15.5, height: 1),
                          textAlign: TextAlign.left),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 30,
                        child: new Text(
                          "VM",
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.lightGreen),
                        )),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_WAIT_ORDER);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.store_mall_directory),
                            label: new Text("待命"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_SHUTDOWN);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.shutter_speed),
                            label: new Text("关机"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_RESTART);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.restore),
                            label: new Text("重启"))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(40.0, 10, 10, 10),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_NET_TEST);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.network_check),
                            label: new Text("测网"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_CLEAN);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.clear),
                            label: new Text("清理"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_SYS_UPDATE);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.arrow_upward),
                            label: new Text("升级"))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 30,
                        child: new Text(
                          "PC",
                          style: TextStyle(
                              color: Colors.white,
                              backgroundColor: Colors.amberAccent),
                        )),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_PC_RAR);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.insert_drive_file),
                            label: new Text("RAR"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_PC_EPT);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.clear_all),
                            label: new Text("EPT"))),
                    Container(
                        width: 90,
                        margin: const EdgeInsets.fromLTRB(10, 2.5, 10, 2.5),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.TASK_PC_UPGRADE);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.update),
                            label: new Text("更新"))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 130,
                        margin: const EdgeInsets.fromLTRB(40, 10, 10, 10),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.AUTO_VOTE_SET1);
                            },
                            color: Colors.white,
                            icon: Icon(ctrl.autoVote == 1
                                ? Icons.invert_colors_off
                                : Icons.invert_colors),
                            label: new Text(
                                "${ctrl.autoVote == 1 ? "关闭" : "开启"}自动"))),
                    Container(
                        width: 150,
                        margin: const EdgeInsets.all(10),
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.AUTO_VOTE_SET2);
                            },
                            color: Colors.white,
                            icon: Icon(ctrl.overAuto == 1
                                ? Icons.leak_remove
                                : Icons.leak_add),
                            label: new Text(
                                "${ctrl.overAuto == 1 ? "关闭" : "开启"}到票自动"))),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                        width: 90,
                        child: FlatButton.icon(
                            onPressed: () {
                              control(SocketAction.REPORT_STATE_VOTE);
                            },
                            color: Colors.white,
                            icon: Icon(Icons.add_to_queue),
                            label: new Text("投票"))),
                    Container(
                      width: 40,
                      margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                      child: Text('超时',
                          style: TextStyle(fontSize: 15.5, height: 1),
                          textAlign: TextAlign.left),
                    ),
                    Container(
                        width: 45,
                        child: TextField(
                            controller: timeoutCtrl,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10.0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            onChanged: (val) {
                              if (val != "") {
                                control("${SocketAction.FORM1_TIMEOUT}:${val}");
                              }
                            })),
                    Container(
                        width: 45,
                        margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                        child: TextField(
                          controller: replugCtrl,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(10.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              )),
                          onChanged: (val) {
                            setState(() {
                              replugSort = val;
                            });
                          },
                        )),
                    Container(
                        width: 90,
                        child: FlatButton.icon(
                            onPressed: () {
                              if (replugSort != "") {
                                control(
                                    "${SocketAction.TASK_EXEC_REPLUG}:${replugSort}");
                              }
                              setState(() {
                                replugSort = "";
                              });
                            },
                            color: Colors.white,
                            icon: Icon(Icons.send),
                            label: new Text("重置"))),
                  ],
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.fromLTRB(0, voteViewTop, 0, 0),
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: false,
                    header: defaultTargetPlatform == TargetPlatform.iOS
                        ? WaterDropHeader()
                        : WaterDropMaterialHeader(),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    child: ListView.builder(
                        itemCount: projectList.length,
                        itemBuilder: (BuildContext content, int index) {
                          VoteProject voteProject = projectList[index];
                          String projectName = voteProject.projectName;
                          bool dropped = isDroppedProject(projectName);
                          bool topped = isToppedProject(projectName);
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              color: dropped ? Colors.black : Colors.green,
                              elevation: 10.0,
                              margin: EdgeInsets.all(1.0),
                              semanticContainer: true,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Align(
                                      alignment: new FractionalOffset(1.0, 0.0),
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Transform.rotate(
                                            angle: 1.0,
                                            child: Text(
                                              '${voteProject.idType}',
                                              style: TextStyle(
                                                  color:
                                                      Colors.lightGreenAccent),
                                            ),
                                          ))),
                                  ListTile(
                                      leading: Column(
                                          //card里面的子控件
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              child: Text(voteProject.price,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  )),
                                              margin: EdgeInsets.all(3.0),
                                            ),
                                          ]),
                                      title: GestureDetector(
                                        child: Text(
                                          '${voteProject.projectName}(${voteProject.hot})',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22),
                                        ),
                                        onTap: () {
                                          _launchURL(
                                              voteProject.backgroundAddress);
                                        },
                                        onLongPress: () {
                                          control(
                                              "${SocketAction.AUTO_VOTE_INDEX_NAME_START}:${voteProject.projectName}");
                                        },
                                      ),
                                      trailing: Text(
                                        '${voteProject.remains} ${topped ? "顶" : ""}',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15),
                                      )),
                                ],
                              ),
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                  caption: '${topped ? "取消" : ""}置顶',
                                  color: Colors.blue,
                                  icon: Icons.vertical_align_top,
                                  onTap: () => control(
                                      "${SocketAction.TOP_PROJECT}:${projectName}|${topped}")),
                              IconSlideAction(
                                  caption: '${dropped ? "取消" : ""}拉黑',
                                  color: Colors.red,
                                  icon: Icons.block,
                                  onTap: () => control(
                                      "${SocketAction.DROP_PROJECT}:${projectName}|${dropped}")),
                            ],
                          );
                        }))),
          ],
        ));
  }

  @override
  void dispose() {
    print("channer ${ctrl.identity}_mobi close");
    channel.sink.close();
    _refreshController.dispose();
    super.dispose();
  }
}
