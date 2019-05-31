import 'package:redux/redux.dart';
import '../action/onlineCtrlAction.dart';
import '../model/appState.dart';
import 'dataset/controller.dart';



class OnlineCtrl extends BaseModel {
  List<Controller> ctrlList;
  final Function loadCtrlList;

  OnlineCtrl(this.ctrlList, this.loadCtrlList);

  factory OnlineCtrl.create(Store<AppState> store) {
    OnlineCtrl onlineCtrl = OnlineCtrl(new List(),
        (userCode,report) => store.dispatch(queryCtrlListAction(userCode,report)));
    store.dispatch(InitOnlineCtrlAction(onlineCtrl));
    return onlineCtrl;
  }
}
