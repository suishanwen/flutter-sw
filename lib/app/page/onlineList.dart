import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:common_utils/common_utils.dart';
import 'package:progress_hud/progress_hud.dart';
import '../../model/onlineCtrl.dart';
import '../../reducer/combineRecuder.dart';

class OnlineList extends StatefulWidget {
  final String userCode;

  OnlineList(this.userCode);

  @override
  _OnlineListState createState() => new _OnlineListState();
}

class _OnlineListState extends State<OnlineList> {
  ProgressHUD _progressHUD;

  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
      loading: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, OnlineCtrl>(converter: (store) {
      OnlineCtrl onlineCtrl;
      if (!store.state.onlineCtrl.init) {
        onlineCtrl = OnlineCtrl.create(store);
        onlineCtrl.loadCtrlList(widget.userCode);
      } else {
        onlineCtrl = store.state.onlineCtrl;
      }
      return onlineCtrl;
    }, builder: (context, onlineCtrl) {
      new Future.delayed(const Duration(seconds: 0), () {
        if (!onlineCtrl.loading) {
          setState(() {
            _progressHUD.state.dismiss();
          });
        } else if (onlineCtrl.loading) {
          setState(() {
            _progressHUD.state.show();
          });
        }
      });
      Color getColor(DateTime dateTime) {
        return DateUtil.getNowDateMs() - dateTime.millisecondsSinceEpoch <
                1000 * 60 * 3
            ? Colors.green
            : Colors.grey;
      }

      List<Controller> ctrlList = onlineCtrl.ctrlList;
      return Scaffold(
        body: new Stack(children: [
          Container(
            child: ListView.builder(
                itemCount: ctrlList.length,
                itemBuilder: (BuildContext content, int index) {
                  Controller ctrl = ctrlList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      child: new Text((index + 1).toString(),
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                          )),
                      backgroundColor: getColor(ctrl.update),
                    ),
                    title: Text(ctrl.identity),
                    subtitle:
                        ctrl.arrDrop.isNotEmpty ? Text("${ctrl.arrDrop}",style: TextStyle(
                          fontSize: 8.0,
                          color: Colors.red,
                        )) : null,
                    trailing: new Text(TimelineUtil.formatByDateTime(
                        ctrl.update,
                        dayFormat: DayFormat.Full)),
                  );
                }),
          ),
          _progressHUD,
        ]),
        floatingActionButton: new FloatingActionButton(
          tooltip: '刷新', // used by assistive technologies
          child: new Icon(Icons.refresh),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            onlineCtrl.loadCtrlList(widget.userCode);
          },
        ),
      );
    });
  }
}
