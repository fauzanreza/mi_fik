import 'dart:convert';
import 'dart:ffi';

class ContentModel {
  String id;
  String slugName;
  String contentTitle;
  String reminder;

  //Nullable
  String contentDesc;
  String contentImage;
  var contentTag;
  var contentLoc;
  var contentAttach;

  //Properties
  String createdAt;
  String dateStart;
  String dateEnd;
  String timeStart;
  String timeEnd;
  String totalViews;
  int isDraft;

  String userId;

  String dataFrom; //For sql union

  ContentModel(
      {this.id,
      this.slugName,
      this.contentTitle,
      this.contentDesc,
      this.contentLoc,
      this.contentAttach,
      this.contentImage,
      this.dateStart,
      this.dateEnd,
      this.timeStart,
      this.timeEnd,
      this.contentTag,
      this.createdAt,
      this.totalViews,
      this.reminder,
      this.isDraft,
      this.userId
      //this.dataFrom
      });

  factory ContentModel.fromJson(Map<String, dynamic> map) {
    return ContentModel(
      id: map["id"],
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"].toString(),
      contentLoc: map["content_loc"],
      contentAttach: map["content_attach"],
      contentImage: map["content_image"].toString(),
      dateStart: map["content_date_start"],
      dateEnd: map["content_date_end"],
      contentTag: map["content_tag"],
      createdAt: map["created_at"],
      totalViews: map["total_views"].toString(),
      //dataFrom: map["data_from"].toString()
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "content_title": contentTitle,
      "content_desc": contentDesc,
      "content_tag": contentTag,
      "content_loc": contentLoc,
      "content_attach": contentAttach,
      "content_date_start": dateStart,
      "content_date_end": dateEnd,
      "content_time_start": timeStart,
      "content_time_end": timeEnd,
      "content_reminder": reminder,
      "content_image": contentImage,
      "is_draft": isDraft
    };
  }
}

List<ContentModel> ContentModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentModel>.from(
      data['data'].map((item) => ContentModel.fromJson(item)));
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