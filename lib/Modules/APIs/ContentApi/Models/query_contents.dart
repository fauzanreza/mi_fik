import 'dart:convert';

// Usecase get all content header
class ContentHeaderModel {
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

  ContentHeaderModel({
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
  });

  factory ContentHeaderModel.fromJson(Map<String, dynamic> map) {
    return ContentHeaderModel(
      id: map["id"],
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"].toString(),
      contentLoc: map["content_loc"],
      contentImage: map["content_image"].toString(),
      dateStart: map["content_date_start"],
      dateEnd: map["content_date_end"],
      contentTag: map["content_tag"],
      createdAt: map["created_at"],
      totalViews: map["total_views"].toString(),
    );
  }
}

List<ContentHeaderModel> ContentHeaderModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentHeaderModel>.from(
      data['data']['data'].map((item) => ContentHeaderModel.fromJson(item)));
}

// Usecase get content detail
class ContentDetailModel {
  String slugName;
  String contentTitle;
  var contentTag;

  //Nullable
  String adminUsernameCreated;
  String userUsernameCreated;
  String adminUsernameUpdated;
  String userUsernameUpdated;

  String contentDesc;
  String contentImage;
  var contentAttach;
  var contentLoc;

  //Properties
  String createdAt;
  String updatedAt;
  String dateStart;
  String dateEnd;
  String totalViews;
  String isDraft;

  ContentDetailModel(
      {this.slugName,
      this.contentTitle,
      this.contentDesc,
      this.contentLoc,
      this.adminUsernameCreated,
      this.userUsernameCreated,
      this.adminUsernameUpdated,
      this.userUsernameUpdated,
      this.contentImage,
      this.contentAttach,
      this.dateStart,
      this.dateEnd,
      this.contentTag,
      this.createdAt,
      this.updatedAt,
      this.totalViews,
      this.isDraft});

  factory ContentDetailModel.fromJson(Map<String, dynamic> map) {
    return ContentDetailModel(
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"].toString(),
      contentLoc: map["content_loc"],
      contentImage: map["content_image"].toString(),
      contentAttach: map["content_attach"],
      adminUsernameCreated: map["admin_username_created"],
      userUsernameCreated: map["user_username_created"],
      adminUsernameUpdated: map["admin_username_updated"],
      userUsernameUpdated: map["user_username_updated"],
      dateStart: map["content_date_start"],
      dateEnd: map["content_date_end"],
      contentTag: map["content_tag"],
      createdAt: map["created_at"],
      updatedAt: map["updated_at"],
      totalViews: map["total_views"].toString(),
      isDraft: map["is_draft"].toString(),
    );
  }
}

List<ContentDetailModel> ContentDetailModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentDetailModel>.from(
      data['data'].map((item) => ContentDetailModel.fromJson(item)));
}

// Usecase get all content & task header (schedule)
class ScheduleModel {
  String slugName;
  String contentTitle;

  //Nullable
  String contentDesc;
  var contentTag;
  var contentLoc;

  //Properties
  String dateStart;
  String dateEnd;
  int dataFrom;

  ScheduleModel(
      {this.slugName,
      this.contentTitle,
      this.contentDesc,
      this.contentLoc,
      this.dateStart,
      this.dateEnd,
      this.contentTag,
      this.dataFrom});

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"].toString(),
      contentTag: map["content_tag"],
      contentLoc: map["content_loc"],
      dateStart: map["content_date_start"],
      dateEnd: map["content_date_end"],
      dataFrom: map["data_from"],
    );
  }
}

List<ScheduleModel> ScheduleModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<ScheduleModel>.from(
      data['data']['data'].map((item) => ScheduleModel.fromJson(item)));
}

class ScheduleTotalModel {
  int content;
  int task;

  ScheduleTotalModel({this.content, this.task});

  factory ScheduleTotalModel.fromJson(Map<String, dynamic> map) {
    return ScheduleTotalModel(
      content: map["content"],
      task: map["task"],
    );
  }
}

List<ScheduleTotalModel> ScheduleTotalModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ScheduleTotalModel>.from(
      data['total'].map((item) => ScheduleTotalModel.fromJson(item)));
}
