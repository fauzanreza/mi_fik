import 'dart:convert';

class ArchieveModel {
  //Key
  int id; //Primary
  String idUser; //Foreign->user

  String archieveName;
  String event;
  String task;

  String createdAt;
  String updatedAt;

  ArchieveModel({
    this.id,
    this.idUser,
    this.archieveName,
    this.event,
    this.task,
    this.createdAt,
    this.updatedAt,
  });

  factory ArchieveModel.fromJson(Map<String, dynamic> map) {
    return ArchieveModel(
        id: map["id"],
        idUser: map["id_user"],
        archieveName: map["archieve_name"],
        event: map["event"],
        task: map["task"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"]);
  }

  // Map<String, dynamic> toJson() {
  //   return {"fullname": fullname};
  // }

  // @override
  // String toString() {
  //   return '{fullname: $fullname}';
  // }
}

List<ArchieveModel> ArchieveModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ArchieveModel>.from(
      data.map((item) => ArchieveModel.fromJson(item)));
}

// String ArchieveModelToJson(ArchieveModel data) {
//   final jsonData = data.toJson();
//   return json.encode(jsonData);
// }
