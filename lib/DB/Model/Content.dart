import 'dart:convert';

class ContentModel {
  //Key
  int id; //Primary
  int idUser; //Foreign->user

  String contentTitle;
  String contentDesc;
  var contentTag;
  var contentLoc;

  String createdAt;
  String updatedAt;
  String dateStart;
  String dateEnd;

  ContentModel({
    this.id,
    this.contentTitle,
    this.contentDesc,
    this.contentTag,
    this.contentLoc,
    this.createdAt,
    this.updatedAt,
    this.dateStart,
    this.dateEnd,
  });

  factory ContentModel.fromJson(Map<String, dynamic> map) {
    return ContentModel(
        id: map["id"],
        contentTitle: map["content_title"],
        contentDesc: map["content_desc"],
        contentTag: map["content_tag"],
        contentLoc: map["content_loc"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
        dateStart: map["content_date_start"],
        dateEnd: map["content_date_end"]);
  }

  // Map<String, dynamic> toJson() {
  //   return {"fullname": fullname};
  // }

  // @override
  // String toString() {
  //   return '{fullname: $fullname}';
  // }
}

List<ContentModel> ContentModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentModel>.from(
      data.map((item) => ContentModel.fromJson(item)));
}

// String contentModelToJson(contentModel data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }
