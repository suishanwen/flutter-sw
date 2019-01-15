import 'package:redux/redux.dart';
import '../model/user.dart';
import '../action/loginAction.dart';
import '../util/sharedPreference.dart';

final loginReducer = combineReducers<User>([
  TypedReducer<User, InitUserAction>(_init),
  TypedReducer<User, UserCodeAction>(_userCode),
  TypedReducer<User, LoginAction>(_login),
]);

User _init(User prev, action) {
  action.user.setInit(true);
  return action.user;
}

User _userCode(User prev, action) {
  prev.userCode = action.userCode;
  return prev;
}

User _login(User prev, action) {
  SharedPreferenceUtil.set("userCode", action.userCode);
  prev.userCode = action.userCode;
  prev.autoLogin = true;
  return prev;
}
