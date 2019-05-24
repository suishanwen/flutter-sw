import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';
import '../action/onlineCtrlAction.dart';
import '../model/appState.dart';

part 'onlineCtrl.g.dart';

@JsonSerializable()
class Controller {
  String identity;
  String uname;
  int startNum;
  int endNum;
  String workerId;
  int tail;
  int autoVote;
  String user;
  int sort;

  Controller();

  factory Controller.fromJson(Map<String, dynamic> json) =>
      _$ControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ControllerToJson(this);
}

class OnlineCtrl extends Base {
  List<Controller> ctrlList;
  final Function loadCtrlList;

  OnlineCtrl(this.ctrlList, this.loadCtrlList);

  factory OnlineCtrl.create(Store<AppState> store) {
    OnlineCtrl onlineCtrl = OnlineCtrl(new List(),
        (userCode) => store.dispatch(queryCtrlListAction(userCode)));
    store.dispatch(InitOnlineCtrlAction(onlineCtrl));
    return onlineCtrl;
  }
}
