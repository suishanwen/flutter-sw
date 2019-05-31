// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voteProject.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteProject _$VoteProjectFromJson(Map<String, dynamic> json) {
  return VoteProject(
      json['projectName'] as String,
      json['ip'] as int,
      json['price'] as String,
      json['idType'] as String,
      json['hot'] as String,
      json['remains'] as String,
      json['finishQuantity'] as String,
      json['totalRequire'] as String,
      json['downloadAddress'] as String,
      json['backgroundNo'] as String,
      json['backgroundAddress'] as String,
      json['refreshDate'] as String);
}

Map<String, dynamic> _$VoteProjectToJson(VoteProject instance) =>
    <String, dynamic>{
      'projectName': instance.projectName,
      'ip': instance.ip,
      'price': instance.price,
      'idType': instance.idType,
      'hot': instance.hot,
      'remains': instance.remains,
      'finishQuantity': instance.finishQuantity,
      'totalRequire': instance.totalRequire,
      'downloadAddress': instance.downloadAddress,
      'backgroundNo': instance.backgroundNo,
      'backgroundAddress': instance.backgroundAddress,
      'refreshDate': instance.refreshDate
    };
