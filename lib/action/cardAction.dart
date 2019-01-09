import 'dart:convert';

import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'dart:io';
import '../reducer/combineRecuder.dart';
import '../model/telCard.dart';

var httpClient = new HttpClient();

class InitTelCardAction {
  final TelCard telCard;

  InitTelCardAction(this.telCard);
}

class LoadTelCardList {
  final List<CardInfo> cardList;

  LoadTelCardList(this.cardList);
}

ThunkAction<AppState> queryCardListAction(String userCode) {
  return (Store<AppState> store) async {
    List<CardInfo> cardList = new List<CardInfo>();
    var uri = new Uri.http(
        'bitcoinrobot.cn:8000', '/queryData/', {'user': userCode});
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    List<dynamic> data = json.decode(responseBody);
    data.forEach((f){
      cardList.add(new CardInfo.fromJson(json.decode(json.encode(f))));
    });
    store.dispatch(LoadTelCardList(cardList));
  };
}

class SaveTelCardInfo {
  final CardInfo cardInfo;

  SaveTelCardInfo(this.cardInfo);
}

class DelTelCardInfo {
  final String pk;

  DelTelCardInfo(this.pk);
}

class QueryNet {
  final String pk;

  QueryNet(this.pk);
}
