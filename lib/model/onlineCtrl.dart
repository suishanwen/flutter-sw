import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';
import '../action/onlineCtrlAction.dart';
import '../model/appState.dart';

part 'onlineCtrl.g.dart';

@JsonSerializable()
class Controller {
  int id;
  String identity;
  String arrDrop;
  DateTime update;

  Controller(this.id, this.identity, this.arrDrop, this.update);

  factory Controller.fromJson(Map<String, dynamic> json) =>
      _$ControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ControllerToJson(this);
}

class OnlineCtrl {
  bool init;
  bool loading;
  List<Controller> ctrlList;
  final Function loadCtrlList;

  OnlineCtrl(this.init, this.loading, this.ctrlList, this.loadCtrlList);

  factory OnlineCtrl.create(Store<AppState> store) {
    OnlineCtrl onlineCtrl = OnlineCtrl(true, false, new List(),
        (userCode) => store.dispatch(queryCtrlListAction(userCode)));
    store.dispatch(InitOnlineCtrlAction(onlineCtrl));
    return onlineCtrl;
  }
}
