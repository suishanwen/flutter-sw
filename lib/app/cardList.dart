import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../model/telCard.dart';
import '../reducer/combineRecuder.dart';

class CardList extends StatefulWidget {
  final String userCode;

  CardList(this.userCode);

  @override
  _CardState createState() => new _CardState();
}

class _CardState extends State<CardList> {
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
      List<CardInfo> cardList = card.cardList;
      return new Text(cardList.length.toString());
    });
  }
}
