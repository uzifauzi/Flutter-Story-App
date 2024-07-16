// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stories_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoriesResponse _$StoriesResponseFromJson(Map<String, dynamic> json) =>
    StoriesResponse(
      json['error'] as bool,
      json['message'] as String,
      (json['listStory'] as List<dynamic>)
          .map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoriesResponseToJson(StoriesResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      json['id'] as String,
      json['name'] as String,
      json['description'] as String,
      json['photoUrl'] as String,
      DateTime.parse(json['createdAt'] as String),
      (json['lat'] as num?)?.toDouble(),
      (json['lon'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
