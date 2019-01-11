import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
      List<CardInfo> cardList = card.cardList;
      return Scaffold(
        body: new Stack(children: [
          Container(
            child: ListView.builder(
                itemCount: cardList.length,
                itemBuilder: (BuildContext content, int index) {
                  CardInfo cardInfo = cardList[index];
                  return ListTile(
                    leading:
                        CircleAvatar(child: new Text(cardInfo.sort.toString())),
                    title: Text("${cardInfo.phone}    ${cardInfo.remark}"),
                    subtitle: Text(cardInfo.net),
                    trailing: new Text(TimelineUtil.formatByDateTime(
                        cardInfo.update,
                        dayFormat: DayFormat.Full)),
                    onLongPress: () {
                      card.queryNet(cardInfo.id, widget.userCode);
                    },
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
            card.loadCardList(widget.userCode);
          },
        ),
      );
    });
  }
}
