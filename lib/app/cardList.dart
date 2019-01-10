import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:common_utils/common_utils.dart';
import 'package:progress_hud/progress_hud.dart';
import '../model/telCard.dart';
import '../reducer/combineRecuder.dart';

class CardList extends StatefulWidget {
  final String userCode;

  CardList(this.userCode);

  @override
  _CardState createState() => new _CardState();
}

class _CardState extends State<CardList> {
  ProgressHUD _progressHUD;

  List<TableRow> buildGrid(cardList) {
    List<TableRow> rows = [];
    rows.add(new TableRow(
      children: <Widget>[
        new TableCell(
          child: new Center(
            child: new Text('序号'),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new Text('手机号'),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new Text('流量'),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new Text('更新时间'),
          ),
        ),
      ],
    ));
    for (var item in cardList) {
      rows.add(new TableRow(children: <TableCell>[
        new TableCell(
          child: new Center(
            child: new Text(item.sort.toString()),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new Text(item.phone),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new AutoSizeText(
              item.net,
              style: TextStyle(fontSize: 5.0),
              maxLines: 10,
            ),
          ),
        ),
        new TableCell(
          child: new Center(
            child: new Text(TimelineUtil.formatByDateTime(item.update,
                dayFormat: DayFormat.Full)),
          ),
        ),
      ]));
    }
    return rows;
  }

  List<Widget> buildContainer(cardList, queryNet) {
    List<Widget> list = [];
    for (var i = 0; i < cardList.length; i++) {
      CardInfo card = cardList[i];
      list.add(new Positioned(
          left: 20.0 + (i % 2) * 200,
          top: 20.0 + (i ~/ 2) * 200,
          child: Container(
            width: 150,
            height: 150,
            child: FlipCard(
              direction: FlipDirection.HORIZONTAL, // default
              front: Container(
                color: Colors.teal,
                child: Text(
                  '序号：${card.sort}\n'
                      '手机号：${card.phone}\n'
                      '流量：${card.net}\n'
                      '备注：${card.remark}\n'
                      '更新：${TimelineUtil.formatByDateTime(card.update, dayFormat: DayFormat.Full)}',
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              ),
              back: Container(
                  color: Colors.teal,
                  child: new Center(
                    child: new RaisedButton(
                      onPressed: () {
                        queryNet(card.id, widget.userCode);
                      },
                      color: Colors.green,
                      //按钮的背景颜色
                      padding: EdgeInsets.all(10.0),
                      //按钮距离里面内容的内边距
                      child: new Text('查询'),
                      textColor: Colors.white,
                      //文字的颜色
                      textTheme: ButtonTextTheme.normal,
                      //按钮的主题
                      onHighlightChanged: (bool b) {
                        //水波纹高亮变化回调
                      },
                      disabledTextColor: Colors.black54,
                      //按钮禁用时候文字的颜色
                      disabledColor: Colors.black54,
                      //按钮被禁用的时候显示的颜色
                      highlightColor: Colors.yellowAccent,
                      //点击或者toch控件高亮的时候显示在控件上面，水波纹下面的颜色
                      splashColor: Colors.white,
                      //水波纹的颜色
                      colorBrightness: Brightness.light,
                      //按钮主题高亮
                      elevation: 10.0,
                      //按钮下面的阴影
                      highlightElevation: 10.0,
                      //高亮时候的阴影
                      disabledElevation: 10.0, //按下的时候的阴影
//              shape:,//设置形状  LearnMaterial中有详解
                    ),
                  )),
            ),
          )));
    }
    list.add(_progressHUD);
    return list;
  }

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
    return new StoreConnector<AppState, TelCard>(converter: (store) {
      TelCard card;
      if (!store.state.card.init) {
        card = TelCard.create(store);
        card.loadCardList(widget.userCode);
      } else {
        card = store.state.card;
      }
      return card;
    }, builder: (context, card) {
      new Future.delayed(const Duration(seconds: 0), () {
        if (!card.loading) {
          setState(() {
            _progressHUD.state.dismiss();
          });
        } else if (card.loading) {
          setState(() {
            _progressHUD.state.show();
          });
        }
      });
      return new Scaffold(
        body: new Stack(children: buildContainer(card.cardList, card.queryNet)),
        floatingActionButton: new FloatingActionButton(
          tooltip: '刷新', // used by assistive technologies
          child: new Icon(Icons.refresh),
          onPressed: () {
            card.loadCardList(widget.userCode);
          },
        ),
      );
    });
  }
}
