
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

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['id'] = id;
		data['description'] = description;
		data['votes'] = votes;
		data['author'] = author;
		data['date'] = date;
		data['gifURL'] = gifURL;
		data['gifSize'] = gifSize;
		data['previewURL'] = previewURL;
		data['videoURL'] = videoURL;
		data['videoPath'] = videoPath;
		data['videoSize'] = videoSize;
		data['type'] = type;
		data['width'] = width;
		data['height'] = height;
		data['commentsCount'] = commentsCount;
		data['fileSize'] = fileSize;
		data['canVote'] = canVote;
		return data;
	}
}
