import '../model/appState.dart';
import 'loginReducer.dart';
import 'pageReducer.dart';
import 'cardReducer.dart';
import 'baseRecuder.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    base: baseReducer(state.base, action),
    user: loginReducer(state.user, action),
    page: pageReducer(state.page, action),
    card: cardReducer(state.card, action),
  );
}
