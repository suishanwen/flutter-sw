// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Controller _$ControllerFromJson(Map<String, dynamic> json) {
  return Controller()
    ..identity = json['identity'] as String
    ..uname = json['uname'] as String
    ..startNum = json['startNum'] as int
    ..endNum = json['endNum'] as int
    ..workerId = json['workerId'] as String
    ..workerInput = json['workerInput'] as int
    ..tail = json['tail'] as int
    ..timeout = json['timeout'] as int
    ..autoVote = json['autoVote'] as int
    ..overAuto = json['overAuto'] as int
    ..user = json['user'] as String
    ..sort = json['sort'] as int
    ..dropped = json['dropped'] as String
    ..droppedTemp = json['droppedTemp'] as String
    ..topped = json['topped'] as String;
}

Map<String, dynamic> _$ControllerToJson(Controller instance) =>
    <String, dynamic>{
      'identity': instance.identity,
      'uname': instance.uname,
      'startNum': instance.startNum,
      'endNum': instance.endNum,
      'workerId': instance.workerId,
      'workerInput': instance.workerInput,
      'tail': instance.tail,
      'timeout': instance.timeout,
      'autoVote': instance.autoVote,
      'overAuto': instance.overAuto,
      'user': instance.user,
      'sort': instance.sort,
      'dropped': instance.dropped,
      'droppedTemp': instance.droppedTemp,
      'topped': instance.topped
    };
