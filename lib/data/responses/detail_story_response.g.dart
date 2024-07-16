// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailStoryResponse _$DetailStoryResponseFromJson(Map<String, dynamic> json) =>
    DetailStoryResponse(
      json['error'] as bool,
      json['message'] as String,
      Story.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetailStoryResponseToJson(
        DetailStoryResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };
