import 'user.dart';
import 'page.dart';
import 'telCard.dart';
import 'onlineCtrl.dart';

class Base {
  bool init = false;
  bool loading = false;

  Base();

  void setInit(bool init) {
    this.init = init;
  }

  void setLoading(bool loading) {
    this.loading = loading;
  }
}

class AppState {
  User user;
  Page page;
  TelCard card;
  OnlineCtrl onlineCtrl;

  AppState({this.user, this.page, this.card, this.onlineCtrl});

  factory AppState.init() {
    return new AppState(
      user: new User('', null, null),
      page: new Page(0, null),
      card: new TelCard(new List<CardInfo>(), null, null),
      onlineCtrl: new OnlineCtrl(new List<Controller>(), null),
    );
  }
}
