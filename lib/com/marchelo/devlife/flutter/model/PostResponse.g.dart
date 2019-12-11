// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostResponse _$PostResponseFromJson(Map<String, dynamic> json) {
  return PostResponse(
    result: (json['result'] as List)
        ?.map((e) =>
            e == null ? null : PostItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    totalCount: json['totalCount'] as int,
  );
}

Map<String, dynamic> _$PostResponseToJson(PostResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'totalCount': instance.totalCount,
    };
