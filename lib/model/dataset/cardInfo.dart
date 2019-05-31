import 'package:json_annotation/json_annotation.dart';

part 'cardInfo.g.dart';

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
