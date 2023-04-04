import 'dart:convert';

class TagModel {
  String slugName;
  String tagName;

  TagModel({
    this.slugName,
    this.tagName,
  });

  factory TagModel.fromJson(Map<String, dynamic> map) {
    return TagModel(slugName: map["slug_name"], tagName: map["tag_name"]);
  }

  // Map<String, dynamic> toJson() {
  //   return {"fullname": fullname};
  // }

  // @override
  // String toString() {
  //   return '{fullname: $fullname}';
  // }
}

List<TagModel> TagModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagModel>.from(
      data['data']['data'].map((item) => TagModel.fromJson(item)));
}

// String TagModelToJson(TagModel data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }
