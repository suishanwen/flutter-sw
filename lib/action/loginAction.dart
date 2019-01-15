import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import '../model/appState.dart';
import '../model/user.dart';

class InitUserAction {
  final User user;

  InitUserAction(this.user);
}

ThunkAction<AppState> asyncInitUserAction(User user) {
  return (Store<AppState> store) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userCode = prefs.getString("userCode");
    if (userCode == null) {
      user.autoLogin = true;
    }
    user.userCode = userCode == null ? '' : userCode;
    store.dispatch(InitUserAction(user));
  };
}

class UserCodeAction {
  final String userCode;

  UserCodeAction(this.userCode);
}

class LoginAction {
  final String userCode;

  LoginAction(this.userCode);
}
