import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:common_utils/common_utils.dart';
import 'package:sw/model/dataset/cardInfo.dart';
import '../../model/telCard.dart';
import '../../model/appState.dart';
import 'log.dart';

class CardList extends StatefulWidget {
  final String userCode;

  CardList(this.userCode);

  @override
  _CardState createState() => new _CardState();
}

class _CardState extends State<CardList> {
  @override
  void initState() {
    super.initState();
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
      Widget dynamicWidget() {
        if (card.logging) {
          return new AlertDialog(
            title: new Text("查询"),
            content: new Log("1"),
          );
        } else {
          return new Container(width: 0,height: 0,);
        }
      }

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
                    title: Text("${cardInfo.remark}",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black87,
                          fontWeight: FontWeight.w400,
                        )),
                    subtitle: Text(cardInfo.net,
                        style: TextStyle(
                          fontSize: 15.0,
                        )),
                    trailing: new Text(
                        "${cardInfo.phone}\n${TimelineUtil.formatByDateTime(cardInfo.update, dayFormat: DayFormat.Common)}",
                        style:
                            TextStyle(fontSize: 10.0, color: Colors.black87)),
                    onLongPress: () {
                      card.queryNet(cardInfo.id, widget.userCode);
                    },
                  );
                }),
          ),
          dynamicWidget()
        ]),
        floatingActionButton: new FloatingActionButton(
          tooltip: '刷新', // used by assistive technologies
          child: new Icon(card.logging ? Icons.do_not_disturb : Icons.refresh),
          backgroundColor: Colors.grey,
          onPressed: () {
            if (card.logging) {
              return;
            }
            card.loadCardList(widget.userCode);
          },
        ),
      );
    });
  }
}
