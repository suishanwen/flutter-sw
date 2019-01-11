import '../model/user.dart';
import '../model/page.dart';
import '../model/telCard.dart';
import '../model/onlineCtrl.dart';
import 'loginReducer.dart';
import 'pageReducer.dart';
import 'cardReducer.dart';
import 'onlineCtrlReducer.dart';

class AppState {
  User user;
  Page page;
  TelCard card;
  OnlineCtrl onlineCtrl;

  AppState({this.user, this.page, this.card, this.onlineCtrl});
}

AppState appReducer(AppState state, action) {
  return AppState(
    user: loginReducer(state.user, action),
    page: pageReducer(state.page, action),
    card: cardReducer(state.card, action),
    onlineCtrl: onlineCtrlReducer(state.onlineCtrl, action),
  );
}
