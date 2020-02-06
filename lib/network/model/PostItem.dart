import 'package:json_annotation/json_annotation.dart';

part 'PostItem.g.dart';

class AnimationType {
	static const String COUB = "coub";
	static const String GIF = "gif";
}

@JsonSerializable()
class PostItem {

  int id;
  String description;
  int votes;
  String author;
  String date;
  String gifURL;
  int gifSize;
  String previewURL;
  String videoURL;
  String videoPath;
  int videoSize;
	String type;
  String width;
  String height;
  int commentsCount;
  int fileSize;
  bool canVote;

	PostItem({
		this.id,
		this.description,
		this.votes,
		this.author,
		this.date,
		this.gifURL,
		this.gifSize,
		this.previewURL,
		this.videoURL,
		this.videoPath,
		this.videoSize,
		this.type,
		this.width,
		this.height,
		this.commentsCount,
		this.fileSize,
		this.canVote
	});

	factory PostItem.fromJson(Map<String, dynamic> json) => _$PostItemFromJson(json);
	Map<String, dynamic> toJson() => _$PostItemToJson(this);

	PostItem.fromJsonMap(Map<String, dynamic> map):
		id = map["id"],
		description = map["description"],
		votes = map["votes"],
		author = map["author"],
		date = map["date"],
		gifURL = map["gifURL"],
		gifSize = map["gifSize"],
		previewURL = map["previewURL"],
		videoURL = map["videoURL"],
		videoPath = map["videoPath"],
		videoSize = map["videoSize"],
		type = map["type"],
		width = map["width"],
		height = map["height"],
		commentsCount = map["commentsCount"],
		fileSize = map["fileSize"],
		canVote = map["canVote"];

	@override
	String toString() {
		return 'PostItem{id: $id}';
	}
}
