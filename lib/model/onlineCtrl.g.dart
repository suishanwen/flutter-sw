// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onlineCtrl.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Controller _$ControllerFromJson(Map<String, dynamic> json) {
  return Controller(json['id'] as int, json['identity'] as String,json['arrDrop'] as String,
      json['update'] == null ? null : DateTime.parse(json['update'] as String));
}

Map<String, dynamic> _$ControllerToJson(Controller instance) =>
    <String, dynamic>{
      'id': instance.id,
      'identity': instance.identity,
      'arrDrop': instance.arrDrop,
      'update': instance.update?.toIso8601String()
    };
