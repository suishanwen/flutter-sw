import 'package:redux/redux.dart';
import '../action/cardAction.dart';
import '../model/appState.dart';
import 'dataset/cardInfo.dart';

class TelCard extends BaseModel {
  List<CardInfo> cardList;
  final Function loadCardList;
  final Function queryNet;
  bool logging;

  TelCard(this.cardList, this.loadCardList, this.queryNet, this.logging);

  factory TelCard.create(Store<AppState> store) {
    TelCard card = TelCard(
        new List(),
        (userCode) => store.dispatch(queryCardListAction(userCode)),
        (pk, userCode) => store.dispatch(queryNetAction(pk, userCode)),
        false);
    store.dispatch(InitTelCardAction(card));
    return card;
  }
}
