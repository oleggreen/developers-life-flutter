import 'package:developerslife_flutter/com/marchelo/devlife/flutter/model/PostItem.dart';

class Response {

  List<PostItem> result;
  int totalCount;

	Response.fromJsonMap(Map<String, dynamic> map): 
		result = List<PostItem>.from(map["result"].map((it) => PostItem.fromJsonMap(it))),
		totalCount = map["totalCount"];

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['result'] = result != null ?  this.result.map((v) => v.toJson()).toList() : null;
		data['totalCount'] = totalCount;
		return data;
	}
}
