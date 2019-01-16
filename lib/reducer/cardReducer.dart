import 'package:redux/redux.dart';
import '../model/telCard.dart';
import '../action/cardAction.dart';

final cardReducer = combineReducers<TelCard>([
  TypedReducer<TelCard, InitTelCardAction>(_init),
  TypedReducer<TelCard, ResetCardInitAction>(_reInit),
  TypedReducer<TelCard, SetLoadingAction>(_loading),
  TypedReducer<TelCard, SetLoggingAction>(_logging),
  TypedReducer<TelCard, LoadTelCardList>(_load),
  TypedReducer<TelCard, SaveTelCardInfo>(_prev),
  TypedReducer<TelCard, DelTelCardInfo>(_prev),
]);

TelCard _init(TelCard prev, action) {
  action.telCard.setInit(true);
  return action.telCard;
}

TelCard _reInit(TelCard prev, action) {
  prev.setInit(false);
  return prev;
}

TelCard _loading(TelCard prev, action) {
  prev.loading = action.loading;
  return prev;
}

TelCard _logging(TelCard prev, action) {
  prev.logging = action.logging;
  return prev;
}

TelCard _load(TelCard prev, action) {
  prev.cardList = action.cardList;
  return prev;
}

TelCard _prev(TelCard prev, action) {
  return prev;
}
