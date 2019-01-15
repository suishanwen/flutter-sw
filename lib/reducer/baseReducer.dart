import 'package:redux/redux.dart';
import '../action/baseAction.dart';
import '../model/appState.dart';

final baseReducer = combineReducers<Base>([
  TypedReducer<Base, LoadingAction>(_loading),
  TypedReducer<Base, InitAction>(_init),
]);

Base _loading(Base prev, action) {
  prev.loading = action.loading;
  return prev;
}

Base _init(Base prev, action) {
  prev.init = action.init;
  return prev;
}
