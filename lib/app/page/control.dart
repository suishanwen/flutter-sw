import 'package:flutter/material.dart';
import 'package:sw/model/onlineCtrl.dart';

class Control extends StatefulWidget {
  final Controller ctrl;

  Control(this.ctrl);

  @override
  _ControlPage createState() => new _ControlPage();
}

class _ControlPage extends State<Control> {
  Controller ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = widget.ctrl;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(ctrl.uname),
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
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),
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
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),
                  Container(
                      margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                      width: 40,
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ))
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                      width: 55,
                      child: Checkbox(
                          activeColor: Colors.blue,
                          tristate: false,
                          value: ctrl.tail == 1,
                          onChanged: (bool bol) {
                            if (mounted) {}
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
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),
                  Container(
                      width: 55,
                      child: Checkbox(
                          activeColor: Colors.blue,
                          tristate: false,
                          value: ctrl.tail == 1,
                          onChanged: (bool bol) {
                            if (mounted) {}
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
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.white,
                          icon: Icon(Icons.store_mall_directory),
                          label: new Text("待命"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.cyanAccent,
                          icon: Icon(Icons.shutter_speed),
                          label: new Text("关机"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.redAccent,
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
                          onPressed: () {},
                          color: Colors.black38,
                          icon: Icon(Icons.network_check),
                          label: new Text("测网"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.green,
                          icon: Icon(Icons.clear),
                          label: new Text("清理"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.deepOrange,
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
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.lime,
                          icon: Icon(Icons.insert_drive_file),
                          label: new Text("RAR"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.pink,
                          icon: Icon(Icons.clear_all),
                          label: new Text("EPT"))),
                  Container(
                      width: 90,
                      margin: const EdgeInsets.all(10),
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.red,
                          icon: Icon(Icons.update),
                          label: new Text("更新"))),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                      width: 90,
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.redAccent,
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
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),
                  Container(
                      width: 45,
                      margin: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      )),
                  Container(
                      width: 90,
                      child: FlatButton.icon(
                          onPressed: () {},
                          color: Colors.amber,
                          icon: Icon(Icons.send),
                          label: new Text("重置"))),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
