import 'package:redux/redux.dart';
import '../model/telCard.dart';
import '../action/cardAction.dart';

final cardReducer = combineReducers<TelCard>([
  TypedReducer<TelCard, InitTelCardAction>(_init),
  TypedReducer<TelCard, ResetInitAction>(_reInit),
  TypedReducer<TelCard, LoadTelCardList>(_load),
  TypedReducer<TelCard, SetLoadingAction>(_loading),
  TypedReducer<TelCard, SaveTelCardInfo>(_prev),
  TypedReducer<TelCard, DelTelCardInfo>(_prev),
]);

TelCard _init(TelCard prev, action) {
  return action.telCard;
}

TelCard _reInit(TelCard prev, action) {
  prev.init = false;
  return prev;
}

TelCard _load(TelCard prev, action) {
  prev.cardList = action.cardList;
  return prev;
}

TelCard _loading(TelCard prev, action) {
  prev.loading = action.loading;
  return prev;
}

TelCard _prev(TelCard prev, action) {
  return prev;
}