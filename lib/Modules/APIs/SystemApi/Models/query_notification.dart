import 'dart:convert';

class NotificationModel {
  String notifTitle;
  String notifBody;

  String createdAt;
  String adminName;

  NotificationModel({
    this.notifTitle,
    this.notifBody,
    this.createdAt,
    this.adminName,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
        notifTitle: map["notif_title"],
        notifBody: map["notif_body"],
        createdAt: map["created_at"],
        adminName: map["admin_fullname"]);
  }
}

List<NotificationModel> notificationJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<NotificationModel>.from(
      data['data']['data'].map((item) => NotificationModel.fromJson(item)));
}
