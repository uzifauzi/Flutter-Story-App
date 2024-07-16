import 'package:json_annotation/json_annotation.dart';

part 'stories_response.g.dart';

@JsonSerializable()
class StoriesResponse {
  StoriesResponse(this.error, this.message, this.listStory);

  bool error;
  String message;
  @JsonKey(name: "listStory")
  List<Story> listStory;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);
}

@JsonSerializable()
class Story {
  Story(this.id, this.name, this.description, this.photoUrl, this.createdAt,
      this.lat, this.lon);

  String id;
  String name;
  String description;
  String photoUrl;
  DateTime createdAt;
  double? lat;
  double? lon;

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
