import 'package:redux/redux.dart';

import '../model/appState.dart';
import '../action/loginAction.dart';
import '../action/cardAction.dart';
import '../action/onlineCtrlAction.dart';

class User extends Base {
  bool autoLogin = false;
  String userCode;
  final Function setUserCode;
  final Function login;

  User(this.userCode, this.setUserCode, this.login);

  factory User.create(Store<AppState> store) {
    User user = User('', (userCode) {
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
