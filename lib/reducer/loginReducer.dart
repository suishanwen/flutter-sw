import 'package:redux/redux.dart';
import '../model/user.dart';
import '../action/loginAction.dart';
import '../util/sharedPreference.dart';

final loginReducer = combineReducers<User>([
  TypedReducer<User, LoginAction>(_login),
  TypedReducer<User, InitUserAction>(_init),
]);

User _login(User prev, action) {
  SharedPreferenceUtil.set("userCode", action.userCode);
  prev.userCode = action.userCode;
  return prev;
}

User _init(User prev, action) {
  return action.user;
}
