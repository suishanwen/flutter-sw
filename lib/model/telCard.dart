import 'package:redux/redux.dart';
import 'package:json_annotation/json_annotation.dart';
import '../reducer/combineRecuder.dart';
import '../action/cardAction.dart';

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


  CardInfo(this.id, this.phone, this.encryptPassword,
      this.icc_id, this.user, this.net, this.remark, this.sort, this.update);

  factory CardInfo.fromJson(Map<String, dynamic> json) => _$CardInfoFromJson(json);
  Map<String, dynamic> toJson() => _$CardInfoToJson(this);
}

class TelCard {
  bool init;
  List<CardInfo> cardList;
  final Function loadCardList;

  TelCard(this.init, this.cardList, this.loadCardList);

  factory TelCard.create(Store<AppState> store) {
    TelCard card = TelCard(true, new List(),
        (userCode) => store.dispatch(queryCardListAction(userCode)));
    store.dispatch(InitTelCardAction(card));
    return card;
  }
}
