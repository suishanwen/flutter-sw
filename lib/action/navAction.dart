import '../model/page.dart';

class SetPageAction {
  final int pageIndex;

  SetPageAction(this.pageIndex);
}

class InitPageAction {
  final Page page;

  InitPageAction(this.page);
}
