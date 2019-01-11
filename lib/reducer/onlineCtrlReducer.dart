import 'package:redux/redux.dart';
import '../model/onlineCtrl.dart';
import '../action/onlineCtrlAction.dart';

final onlineCtrlReducer = combineReducers<OnlineCtrl>([
  TypedReducer<OnlineCtrl, InitOnlineCtrlAction>(_init),
  TypedReducer<OnlineCtrl, ResetOnlineCtrlInitAction>(_reInit),
  TypedReducer<OnlineCtrl, LoadOnlineCtrlList>(_load),
  TypedReducer<OnlineCtrl, SetLoadingAction>(_loading),
]);

OnlineCtrl _init(OnlineCtrl prev, action) {
  return action.onlineCtrl;
}

OnlineCtrl _reInit(OnlineCtrl prev, action) {
  prev.init = false;
  return prev;
}

OnlineCtrl _load(OnlineCtrl prev, action) {
  prev.ctrlList = action.ctrlList;
  return prev;
}

OnlineCtrl _loading(OnlineCtrl prev, action) {
  prev.loading = action.loading;
  return prev;
}

OnlineCtrl _prev(OnlineCtrl prev, action) {
  return prev;
}
