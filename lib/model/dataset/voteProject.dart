import 'package:json_annotation/json_annotation.dart';

part 'voteProject.g.dart';

@JsonSerializable()
class VoteProject {
  String projectName;
  int ip;
  String price;
  String idType;
  String hot;
  String remains;
  String finishQuantity;
  String totalRequire;
  String downloadAddress;
  String backgroundNo;
  String backgroundAddress;
  String refreshDate;

  VoteProject(
      this.projectName,
      this.ip,
      this.price,
      this.idType,
      this.hot,
      this.remains,
      this.finishQuantity,
      this.totalRequire,
      this.downloadAddress,
      this.backgroundNo,
      this.backgroundAddress,
      this.refreshDate);

  factory VoteProject.fromJson(Map<String, dynamic> json) =>
      _$VoteProjectFromJson(json);

  Map<String, dynamic> toJson() => _$VoteProjectToJson(this);
}
