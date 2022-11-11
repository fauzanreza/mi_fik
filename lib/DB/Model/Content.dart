import 'dart:convert';

class ContentModel {
  //Key
  String id; //Primary
  int idUser; //Foreign->user

  String contentTitle;
  String contentSubtitle;
  String contentDesc;
  var contentTag;
  var contentAttach;
  var contentLoc;

  String createdAt;
  String updatedAt;
  String dateStart;
  String dateEnd;

  String dataFrom; //For sql union

  ContentModel(
      {this.id,
      this.contentTitle,
      this.contentSubtitle,
      this.contentDesc,
      this.contentAttach,
      this.contentTag,
      this.contentLoc,
      this.createdAt,
      this.updatedAt,
      this.dateStart,
      this.dateEnd,
      this.dataFrom});

  factory ContentModel.fromJson(Map<String, dynamic> map) {
    return ContentModel(
        id: map["id"].toString(),
        contentTitle: map["content_title"],
        contentSubtitle: map["content_subtitle"],
        contentDesc: map["content_desc"],
        contentTag: map["content_tag"],
        contentAttach: map["content_attach"],
        contentLoc: map["content_loc"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"],
        dateStart: map["content_date_start"],
        dateEnd: map["content_date_end"],
        dataFrom: map["data_from"].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      "content_title": contentTitle,
      "content_subtitle": contentSubtitle,
      "content_desc": contentDesc,
      "content_tag": contentTag,
      "content_attach": contentAttach,
      "content_loc": contentLoc,
      "content_date_start": dateStart,
      "content_date_end": dateEnd
    };
  }
}

List<ContentModel> ContentModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentModel>.from(
      data.map((item) => ContentModel.fromJson(item)));
}

List<ContentModel> ContentModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentModel>.from(
      data['data'].map((item) => ContentModel.fromJson(item)));
}

String ContentModelToJson(ContentModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
