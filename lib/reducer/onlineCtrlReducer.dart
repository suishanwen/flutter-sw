import 'package:redux/redux.dart';
import '../model/onlineCtrl.dart';
import '../action/onlineCtrlAction.dart';

final onlineCtrlReducer = combineReducers<OnlineCtrl>([
  TypedReducer<OnlineCtrl, InitOnlineCtrlAction>(_init),
  TypedReducer<OnlineCtrl, ResetOnlineCtrlInitAction>(_reInit),
  TypedReducer<OnlineCtrl, SetLoadingAction>(_loading),
  TypedReducer<OnlineCtrl, LoadOnlineCtrlList>(_load),
]);

OnlineCtrl _init(OnlineCtrl prev, action) {
  action.onlineCtrl.setInit(true);
  return action.onlineCtrl;
}

OnlineCtrl _reInit(OnlineCtrl prev, action) {
  prev.setInit(false);
  return prev;
}

OnlineCtrl _loading(OnlineCtrl prev, action) {
  prev.setLoading(action.loading);
  return prev;
}

OnlineCtrl _load(OnlineCtrl prev, action) {
  prev.ctrlList = action.ctrlList;
  return prev;
}
