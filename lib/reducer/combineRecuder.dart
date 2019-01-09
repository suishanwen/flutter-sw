import '../model/user.dart';
import '../model/page.dart';
import '../model/telCard.dart';
import 'loginReducer.dart';
import 'pageReducer.dart';
import 'cardReducer.dart';

class AppState {
  User user;
  Page page;
  TelCard card;

  AppState({this.user, this.page, this.card});
}

AppState appReducer(AppState state, action) {
  return AppState(
    user: loginReducer(state.user, action),
    page: pageReducer(state.page, action),
    card: cardReducer(state.card, action),
  );
}
