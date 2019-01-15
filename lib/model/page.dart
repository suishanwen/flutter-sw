import 'package:redux/redux.dart';
import '../model/appState.dart';
import '../action/navAction.dart';

class Page {
  bool init;
  int pageIndex;
  final Function setPageIndex;

  Page(this.init, this.pageIndex, this.setPageIndex);

  factory Page.create(Store<AppState> store) {
    Page page =
        Page(true, 1, (pageIndex) => store.dispatch(SetPageAction(pageIndex)));
    store.dispatch(InitPageAction(page));
    return page;
  }
}
