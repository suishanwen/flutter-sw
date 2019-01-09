import 'package:redux/redux.dart';

import '../reducer/combineRecuder.dart';
import '../action/loginAction.dart';

class User {
  bool init;
  String userCode;
  final Function setUserCode;

  User(this.init, this.userCode, this.setUserCode);

  factory User.create(Store<AppState> store) {
    User user = User(true, '', (user) => store.dispatch(LoginAction(user)));
    store.dispatch(asyncInitUserAction(user));
    return user;
  }
}
