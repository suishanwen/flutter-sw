import 'package:redux/redux.dart';

import '../reducer/combineRecuder.dart';
import '../action/loginAction.dart';
import '../action/cardAction.dart';

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
      store.dispatch(ResetInitAction());
      return store.dispatch(LoginAction(userCode));
    });
    store.dispatch(asyncInitUserAction(user));
    return user;
  }
}
