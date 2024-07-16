import 'package:json_annotation/json_annotation.dart';
import 'stories_response.dart';

part 'detail_story_response.g.dart';

@JsonSerializable()
class DetailStoryResponse {
  DetailStoryResponse(this.error, this.message, this.story);

  bool error;
  String message;
  Story story;

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryResponseToJson(this);
}
