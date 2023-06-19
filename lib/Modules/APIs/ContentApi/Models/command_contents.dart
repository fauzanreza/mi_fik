import 'dart:convert';

// Usecase add post
class ContentModel {
  String id;
  String slugName;
  String contentTitle;
  String reminder;

  //Nullable
  String contentDesc;
  String contentImage;
  String contentTag;
  String contentLoc;
  String contentAttach;

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

String contentModelToJson(ContentModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
