import 'package:sw/model/baseState.dart';

import 'dataset/cardInfo.dart';
import 'dataset/controller.dart';
import 'user.dart';
import 'page.dart';
import 'telCard.dart';
import 'onlineCtrl.dart';

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
  OnlineCtrl onlineCtrl;

  AppState({this.base, this.user, this.page, this.card, this.onlineCtrl});

  factory AppState.init() {
    return new AppState(
      base: new BaseState(),
      user: new User('', null, null),
      page: new Page(0, null),
      card: new TelCard(new List<CardInfo>(), null, null, false),
      onlineCtrl: new OnlineCtrl(new List<Controller>(), null),
    );
  }
}
