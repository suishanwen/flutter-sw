import '../model/user.dart';
import '../model/page.dart';
import 'loginReducer.dart';
import 'pageReducer.dart';

class AppState {
  User user;
  Page page;

  AppState({this.user, this.page});
}

AppState appReducer(AppState state, action) {
  return AppState(
    user: loginReducer(state.user, action),
    page: pageReducer(state.page, action),
  );
}
