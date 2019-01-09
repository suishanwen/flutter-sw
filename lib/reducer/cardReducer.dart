import 'package:redux/redux.dart';
import '../model/telCard.dart';
import '../action/cardAction.dart';

final cardReducer = combineReducers<TelCard>([
  TypedReducer<TelCard, InitTelCardAction>(_init),
  TypedReducer<TelCard, LoadTelCardList>(_load),
  TypedReducer<TelCard, SaveTelCardInfo>(_prev),
  TypedReducer<TelCard, DelTelCardInfo>(_prev),
  TypedReducer<TelCard, QueryNet>(_prev),
]);

TelCard _init(TelCard prev, action) {
  return action.telCard;
}

TelCard _load(TelCard prev, action) {
  prev.cardList = action.cardList;
  return prev;
}

TelCard _prev(TelCard prev, action) {
  return prev;
}
