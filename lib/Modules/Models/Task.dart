import 'dart:convert';

class TaskModel {
  //Key
  String id; //Primary
  int idUser; //Foreign->user

  String taskTitle;
  String taskDesc;

  String createdAt;
  String updatedAt;
  String dateStart;
  String dateEnd;

  TaskModel({
    this.id,
    this.taskTitle,
    this.taskDesc,
    this.createdAt,
    this.updatedAt,
    this.dateStart,
    this.dateEnd,
  });

  factory TaskModel.fromJson(Map<String, dynamic> map) {
    return TaskModel(
        id: map["id"].toString(),
        taskTitle: map["task_title"],
        taskDesc: map["task_desc"],
        dateStart: map["task_date_start"],
        dateEnd: map["task_date_end"],
        createdAt: map["created_at"],
        updatedAt: map["updated_at"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "task_title": taskTitle,
      "task_desc": taskDesc,
      "task_date_start": dateStart,
      "task_date_end": dateEnd
    };
  }
}

List<TaskModel> TaskModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TaskModel>.from(data.map((item) => TaskModel.fromJson(item)));
}

List<TaskModel> TaskModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<TaskModel>.from(
      data['data'].map((item) => TaskModel.fromJson(item)));
}

String TaskModelToJson(TaskModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
