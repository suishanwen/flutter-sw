// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cardInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardInfo _$CardInfoFromJson(Map<String, dynamic> json) {
  return CardInfo(
      json['id'] as int,
      json['phone'] as String,
      json['encryptPassword'] as String,
      json['icc_id'] as String,
      json['user'] as String,
      json['net'] as String,
      json['remark'] as String,
      json['sort'] as int,
      json['update'] == null ? null : DateTime.parse(json['update'] as String));
}

Map<String, dynamic> _$CardInfoToJson(CardInfo instance) => <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'encryptPassword': instance.encryptPassword,
      'icc_id': instance.icc_id,
      'user': instance.user,
      'net': instance.net,
      'remark': instance.remark,
      'sort': instance.sort,
      'update': instance.update?.toIso8601String()
    };
