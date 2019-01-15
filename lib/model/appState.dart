import 'user.dart';
import 'page.dart';
import 'telCard.dart';
import 'onlineCtrl.dart';

class Base {
  bool loading;
  bool init;

  Base(this.loading, this.init);
}

class AppState {
  Base base;
  User user;
  Page page;
  TelCard card;
  OnlineCtrl onlineCtrl;

  AppState({this.base, this.user, this.page, this.card, this.onlineCtrl});

  factory AppState.init() {
    return new AppState(
      base: new Base(false, false),
      user: new User(false, false, '', null, null),
      page: new Page(false, 0, null),
      card: new TelCard(false, false, new List<CardInfo>(), null, null),
      onlineCtrl: new OnlineCtrl(false, false, new List<Controller>(), null),
    );
  }
}
