import 'package:redux/redux.dart';

import '../reducer/combineRecuder.dart';
import '../action/loginAction.dart';
import '../action/cardAction.dart';
import '../action/onlineCtrlAction.dart';

class User {
  bool init;
  String userCode;
  final Function setUserCode;
  final Function login;

  User(this.init, this.userCode, this.setUserCode, this.login);

  factory User.create(Store<AppState> store) {
    User user = User(true, '', (userCode) {
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
