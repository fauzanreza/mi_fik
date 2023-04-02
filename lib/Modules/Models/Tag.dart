import 'dart:convert';

class TagModel {
  //Key
  String id; //Primary

  String tagName;

  String createdAt;
  String updatedAt;

  TagModel({
    this.id,
    this.tagName,
    this.createdAt,
    this.updatedAt,
  });

  factory TagModel.fromJson(Map<String, dynamic> map) {
    return TagModel(
        id: map["id"].toString(),
        tagName: map["tag_name"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"]);
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
  return List<TagModel>.from(data.map((item) => TagModel.fromJson(item)));
}

// String TagModelToJson(TagModel data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }
