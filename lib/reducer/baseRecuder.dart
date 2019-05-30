import 'package:redux/redux.dart';
import 'package:sw/action/baseAction.dart';
import 'package:sw/model/baseState.dart';

final baseReducer = combineReducers<BaseState>([
  TypedReducer<BaseState, LoadingAction>(_loading),
]);

BaseState _loading(BaseState prev, action) {
  prev.setLoading(action.loading);
  return prev;
}
