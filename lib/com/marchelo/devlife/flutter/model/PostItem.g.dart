// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PostItem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostItem _$PostItemFromJson(Map<String, dynamic> json) {
  return PostItem(
    id: json['id'] as int,
    description: json['description'] as String,
    votes: json['votes'] as int,
    author: json['author'] as String,
    date: json['date'] as String,
    gifURL: json['gifURL'] as String,
    gifSize: json['gifSize'] as int,
    previewURL: json['previewURL'] as String,
    videoURL: json['videoURL'] as String,
    videoPath: json['videoPath'] as String,
    videoSize: json['videoSize'] as int,
    type: json['type'] as String,
    width: json['width'] as String,
    height: json['height'] as String,
    commentsCount: json['commentsCount'] as int,
    fileSize: json['fileSize'] as int,
    canVote: json['canVote'] as bool,
  );
}

Map<String, dynamic> _$PostItemToJson(PostItem instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'votes': instance.votes,
      'author': instance.author,
      'date': instance.date,
      'gifURL': instance.gifURL,
      'gifSize': instance.gifSize,
      'previewURL': instance.previewURL,
      'videoURL': instance.videoURL,
      'videoPath': instance.videoPath,
      'videoSize': instance.videoSize,
      'type': instance.type,
      'width': instance.width,
      'height': instance.height,
      'commentsCount': instance.commentsCount,
      'fileSize': instance.fileSize,
      'canVote': instance.canVote,
    };
