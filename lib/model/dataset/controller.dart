import 'package:json_annotation/json_annotation.dart';

part 'controller.g.dart';

@JsonSerializable()
class Controller {
  String identity;
  String uname;
  int startNum;
  int endNum;
  String workerId;
  int workerInput;
  int tail;
  int overTime;
  int autoVote;
  int overAuto;
  String user;
  int sort;

  Controller();

  factory Controller.fromJson(Map<String, dynamic> json) =>
      _$ControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ControllerToJson(this);
}