import 'dart:convert';

// Usecase get all content header
class ContentHeaderModel {
  String id;
  String slugName;
  String contentTitle;

  //Nullable
  String contentDesc;
  String contentImage;
  List<dynamic> contentTag;
  List<dynamic> contentLoc;

  //Properties
  String createdAt;
  String dateStart;
  String dateEnd;
  String totalViews;
  String acUsername;
  String ucUsername;
  String acImage;
  String ucImage;

  ContentHeaderModel(
      {this.id,
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
      this.acUsername,
      this.ucImage,
      this.acImage,
      this.ucUsername});

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
      acUsername: map["admin_username_created"],
      ucUsername: map["user_username_created"],
      acImage: map["admin_image_created"],
      ucImage: map["user_image_created"],
      totalViews: map["total_views"].toString(),
    );
  }
}

List<ContentHeaderModel> contentHeaderModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentHeaderModel>.from(
      data['data']['data'].map((item) => ContentHeaderModel.fromJson(item)));
}

// Usecase get content detail
class ContentDetailModel {
  String slugName;
  String contentTitle;
  List<dynamic> contentTag;

  //Nullable
  String adminUsernameCreated;
  String userUsernameCreated;
  String adminUsernameUpdated;
  String userUsernameUpdated;

  String adminImageCreated;
  String userImageCreated;

  String contentDesc;
  String contentImage;
  List<dynamic> contentAttach;
  List<dynamic> contentLoc;

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
      this.adminImageCreated,
      this.userImageCreated,
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
      adminImageCreated: map["admin_image_created"],
      userImageCreated: map["user_image_created"],
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

List<ContentDetailModel> contentDetailModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ContentDetailModel>.from(
      data['data'].map((item) => ContentDetailModel.fromJson(item)));
}

// Usecase get all content & task header (schedule)
class ScheduleModel {
  String id;
  String slugName;
  String contentTitle;

  //Nullable
  String contentDesc;
  String imageUrl;
  List<dynamic> contentTag;
  List<dynamic> contentLoc;
  String contentImage;
  String acUsername;
  String ucUsername;
  String acImage;
  String ucImage;

  //Properties
  String createdAt;
  String updatedAt;
  String dateStart;
  String dateEnd;
  int dataFrom;
  String totalViews;
  String reminder;

  ScheduleModel(
      {this.id,
      this.slugName,
      this.contentTitle,
      this.contentDesc,
      this.contentLoc,
      this.dateStart,
      this.dateEnd,
      this.contentTag,
      this.contentImage,
      this.dataFrom,
      this.acUsername,
      this.ucImage,
      this.acImage,
      this.ucUsername,
      this.totalViews,
      this.createdAt,
      this.updatedAt,
      this.imageUrl,
      this.reminder});

  factory ScheduleModel.fromJson(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map["id"],
      slugName: map["slug_name"],
      contentTitle: map["content_title"],
      contentDesc: map["content_desc"],
      contentTag: map["content_tag"],
      contentLoc: map["content_loc"],
      contentImage: map["content_image"],
      dateStart: map["content_date_start"],
      dateEnd: map["content_date_end"],
      dataFrom: map["data_from"],
      acUsername: map["admin_username_created"],
      ucUsername: map["user_username_created"],
      acImage: map["admin_image_created"],
      ucImage: map["user_image_created"],
      createdAt: map["created_at"],
      updatedAt: map["updated_at"],
      totalViews: map["total_views"].toString(),
      reminder: map["content_reminder"],
      imageUrl: map["image_url"],
    );
  }
}

List<ScheduleModel> scheduleModelFromJsonWPaginate(String jsonData) {
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

List<ScheduleTotalModel> scheduleTotalModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ScheduleTotalModel>.from(
      data['total'].map((item) => ScheduleTotalModel.fromJson(item)));
}
