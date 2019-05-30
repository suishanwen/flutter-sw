import 'package:redux/redux.dart';
import '../model/appState.dart';
import '../action/navAction.dart';

class Page extends BaseModel {
  int pageIndex;
  final Function setPageIndex;

  Page(this.pageIndex, this.setPageIndex);

  factory Page.create(Store<AppState> store) {
    Page page =
        Page(1, (pageIndex) => store.dispatch(SetPageAction(pageIndex)));
    store.dispatch(InitPageAction(page));
    return page;
  }
}
