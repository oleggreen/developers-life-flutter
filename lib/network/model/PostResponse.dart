import 'PostItem.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PostResponse.g.dart';

@JsonSerializable()
class PostResponse {

  List<PostItem> result;
  int totalCount;

	PostResponse({this.result, this.totalCount});

	factory PostResponse.fromJson(Map<String, dynamic> json) => _$PostResponseFromJson(json);
	Map<String, dynamic> toJson() => _$PostResponseToJson(this);

	PostResponse.fromJsonMap(Map<String, dynamic> map):
		result = List<PostItem>.from(map["result"].map((it) => PostItem.fromJsonMap(it))),
		totalCount = map["totalCount"];
}