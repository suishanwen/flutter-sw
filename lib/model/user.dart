import 'package:redux/redux.dart';

import '../model/appState.dart';
import '../action/loginAction.dart';
import '../action/cardAction.dart';
import '../action/onlineCtrlAction.dart';

class User {
  bool init;
  bool autoLogin;
  String userCode;
  final Function setUserCode;
  final Function login;

  User(this.init, this.autoLogin, this.userCode, this.setUserCode, this.login);

  factory User.create(Store<AppState> store) {
    User user = User(true, false, '', (userCode) {
      return store.dispatch(UserCodeAction(userCode));
    }, (userCode) {
      store.dispatch(ResetCardInitAction());
      store.dispatch(ResetOnlineCtrlInitAction());
      return store.dispatch(LoginAction(userCode));
    });
    store.dispatch(asyncInitUserAction(user));
    return user;
  }
}
