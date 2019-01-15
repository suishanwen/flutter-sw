import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';
import '../action/cardAction.dart';
import '../model/appState.dart';

part 'telCard.g.dart';

@JsonSerializable()
class CardInfo {
  int id;
  String phone;
  String encryptPassword;
  String icc_id;
  String user;
  String net;
  String remark;
  int sort;
  DateTime update;

  CardInfo(this.id, this.phone, this.encryptPassword, this.icc_id, this.user,
      this.net, this.remark, this.sort, this.update);

  factory CardInfo.fromJson(Map<String, dynamic> json) =>
      _$CardInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CardInfoToJson(this);
}

class TelCard extends Base {
  List<CardInfo> cardList;
  final Function loadCardList;
  final Function queryNet;

  TelCard(this.cardList, this.loadCardList, this.queryNet);

  factory TelCard.create(Store<AppState> store) {
    TelCard card = TelCard(
        new List(),
        (userCode) => store.dispatch(queryCardListAction(userCode)),
        (pk, userCode) => store.dispatch(queryNetAction(pk, userCode)));
    store.dispatch(InitTelCardAction(card));
    return card;
  }
}
