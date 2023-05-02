import 'dart:convert';

class NotificationModel {
  //Key
  String id; //Primary

  String notifType;
  String notifBody;
  var notifSendTo;

  String createdAt;
  String adminName;
  String userName;

  NotificationModel({
    this.id,
    this.notifType,
    this.notifBody,
    this.notifSendTo,
    this.adminName,
    this.userName,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
        id: map["id"],
        notifType: map["notif_type"],
        notifBody: map["notif_body"],
        notifSendTo: map["notif_send_to"],
        adminName: map["admins_fullname"],
        userName: map["users_fullname"],
        createdAt: map["created_at"]);
  }
}

List<NotificationModel> notificationJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<NotificationModel>.from(
      data['data']['data'].map((item) => NotificationModel.fromJson(item)));
}
