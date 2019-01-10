import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:common_utils/common_utils.dart';
import '../model/telCard.dart';
import '../reducer/combineRecuder.dart';

class CardList extends StatefulWidget {
  final String userCode;

  CardList(this.userCode);

  @override
  _CardState createState() => new _CardState();
}

class _CardState extends State<CardList> {
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
      return new Scaffold(
          body: new Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(30.0),
                1: FlexColumnWidth(80.0),
                2: FlexColumnWidth(150.0),
                3: FlexColumnWidth(80.0),
              },
              border: new TableBorder.all(width: 1.0, color: Colors.grey),
              children: buildGrid(card.cardList)));
    });
  }
}
