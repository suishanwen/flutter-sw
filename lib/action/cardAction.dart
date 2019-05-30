import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import '../model/appState.dart';
import '../model/telCard.dart';
import 'baseAction.dart';

Dio dio = new Dio();

class InitTelCardAction {
  final TelCard telCard;

  InitTelCardAction(this.telCard);
}

class ResetCardInitAction {
  ResetCardInitAction();
}

class LoadTelCardList {
  final List<CardInfo> cardList;

  LoadTelCardList(this.cardList);
}
class SetLoggingAction {
  final bool logging;

  SetLoggingAction(this.logging);
}


ThunkAction<AppState> queryCardListAction(String userCode) {
  return (Store<AppState> store) async {
    //begin loading
    store.dispatch(LoadingAction(true));
    List<CardInfo> cardList = new List<CardInfo>();
    try {
      var response = await dio
          .get("http://bitcoinrobot.cn:8000/queryData/?user=${userCode}");
      List<dynamic> data = json.decode(response.data);
      data.forEach((f) {
        cardList.add(new CardInfo.fromJson(json.decode(json.encode(f))));
      });
    } catch (Exception) {}
    store.dispatch(LoadTelCardList(cardList));
    //end loading
    store.dispatch(LoadingAction(false));
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

ThunkAction<AppState> queryNetAction(int pk, String userCode) {
  return (Store<AppState> store) async {
    store.dispatch(SetLoggingAction(true));
    try {
      var response = await dio.post("http://bitcoinrobot.cn:8000/queryNet/",
          data: new FormData.from({"pk": pk}));
      if (response.statusCode == 200) {
        new Future.delayed(const Duration(seconds: 0), () {
          store.dispatch(queryCardListAction(userCode));
        });
      }
      store.dispatch(SetLoggingAction(false));
    } catch (Exception) {}
  };
}
