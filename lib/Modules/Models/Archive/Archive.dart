import 'dart:convert';

class ArchiveModel {
  //Key
  int id; //Primary
  String idUser; //Foreign->user

  String archieveName;
  String event;
  String task;

  String createdAt;
  String updatedAt;

  ArchiveModel({
    this.id,
    this.idUser,
    this.archieveName,
    this.event,
    this.task,
    this.createdAt,
    this.updatedAt,
  });

  factory ArchiveModel.fromJson(Map<String, dynamic> map) {
    return ArchiveModel(
        id: map["id"],
        idUser: map["id_user"],
        archieveName: map["archieve_name"],
        event: map["event"],
        task: map["task"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "archieve_name": archieveName,
      "id_user": idUser,
      "user_id": idUser
    }; //Check this again. for user id column in db!
  }
}

String ArchieveModelToJson(ArchiveModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
