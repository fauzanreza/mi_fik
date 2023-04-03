import 'dart:convert';

class ContentModel {
  String id;
  String slugName;
  String contentTitle;

  //Nullable
  String contentDesc;
  String contentImage;
  var contentTag;
  var contentLoc;

  //Properties
  String createdAt;
  String dateStart;
  String dateEnd;
  String totalViews;

  String dataFrom; //For sql union

  ContentModel({
    this.id,
    this.slugName,
    this.contentTitle,
    this.contentDesc,
    this.contentLoc,
    this.contentImage,
    this.dateStart,
    this.dateEnd,
    this.contentTag,
    this.createdAt,
    this.totalViews,
    //this.dataFrom
  });

  factory ContentModel.fromJson(Map<String, dynamic> map) {
    return ContentModel(
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"].toString(),
      contentLoc: map["content_loc"],
      contentImage: map["content_image"].toString(),
      //dateStart: map["content_date_start"],
      //dateEnd: map["content_date_end"],
      contentTag: map["content_tag"],
      createdAt: map["created_at"],
      totalViews: map["total_views"].toString(),
      //dataFrom: map["data_from"].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content_title": contentTitle,
      "content_desc": contentDesc,
      "content_tag": contentTag,
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
      data['data']['data'].map((item) => ContentModel.fromJson(item)));
}

String ContentModelToJson(ContentModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
