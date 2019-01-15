import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import '../model/appState.dart';
import '../model/onlineCtrl.dart';

Dio dio = new Dio();

class InitOnlineCtrlAction {
  final OnlineCtrl onlineCtrl;

  InitOnlineCtrlAction(this.onlineCtrl);
}

class ResetOnlineCtrlInitAction {
  ResetOnlineCtrlInitAction();
}

class LoadOnlineCtrlList {
  final List<Controller> ctrlList;

  LoadOnlineCtrlList(this.ctrlList);
}

class SetLoadingAction {
  final bool loading;

  SetLoadingAction(this.loading);
}

ThunkAction<AppState> queryCtrlListAction(String userCode) {
  return (Store<AppState> store) async {
    //begin loading
    store.dispatch(SetLoadingAction(true));
    List<Controller> ctrlList = new List<Controller>();
    try {
      var response = await dio.post(
          "http://bitcoinrobot.cn:8000/listOnlineData/",
          data: new FormData.from({"user": userCode}));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.data);
        data.forEach((f) {
          ctrlList.add(new Controller.fromJson(json.decode(json.encode(f))));
        });
      }
    } catch (Exception ) {}
    store.dispatch(LoadOnlineCtrlList(ctrlList));
    //end loading
    store.dispatch(SetLoadingAction(false));
  };
}
