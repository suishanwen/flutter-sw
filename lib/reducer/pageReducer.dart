import 'package:redux/redux.dart';
import '../model/page.dart';
import '../action/navAction.dart';

final pageReducer = combineReducers<Page>([
  TypedReducer<Page, InitPageAction>(_init),
  TypedReducer<Page, SetPageAction>(_set),
]);

Page _init(Page prev, action) {
  action.page.setInit(true);
  return action.page;
}

Page _set(Page prev, action) {
  prev.pageIndex = action.pageIndex;
  return prev;
}
