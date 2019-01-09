import 'package:redux/redux.dart';
import '../model/page.dart';
import '../action/navAction.dart';

final pageReducer = combineReducers<Page>([
  TypedReducer<Page, SetPageAction>(_set),
  TypedReducer<Page, InitPageAction>(_init),
]);

Page _set(Page prev, action) {
  prev.pageIndex = action.pageIndex;
  return prev;
}

Page _init(Page prev, action) {
  return action.page;
}
