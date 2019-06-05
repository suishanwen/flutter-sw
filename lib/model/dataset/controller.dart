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
  int timeout;
  int autoVote;
  int overAuto;
  String user;
  int sort;
  String dropped;
  String droppedTemp;
  String topped;

  Controller();

  factory Controller.fromJson(Map<String, dynamic> json) =>
      _$ControllerFromJson(json);

  Map<String, dynamic> toJson() => _$ControllerToJson(this);
}