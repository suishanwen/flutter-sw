import 'package:sw/model/baseState.dart';

import 'dataset/cardInfo.dart';
import 'user.dart';
import 'page.dart';
import 'telCard.dart';

class BaseModel {
  bool init = false;

  BaseModel();

  void setInit(bool init) {
    this.init = init;
  }
}

class AppState {
  BaseState base;
  User user;
  Page page;
  TelCard card;

  AppState({this.base, this.user, this.page, this.card});

  factory AppState.init() {
    return new AppState(
      base: new BaseState(),
      user: new User('', null, null),
      page: new Page(0, null),
      card: new TelCard(new List<CardInfo>(), null, null, false),
    );
  }
}
