import '../model/appState.dart';
import 'loginReducer.dart';
import 'pageReducer.dart';
import 'cardReducer.dart';
import 'onlineCtrlReducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    user: loginReducer(state.user, action),
    page: pageReducer(state.page, action),
    card: cardReducer(state.card, action),
    onlineCtrl: onlineCtrlReducer(state.onlineCtrl, action),
  );
}
