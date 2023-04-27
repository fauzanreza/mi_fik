import 'dart:convert';

// Usecase add task
class AddTaskModel {
  String taskTitle;
  String taskDesc;
  String dateStart;
  String dateEnd;
  String reminder;

  AddTaskModel(
      {this.taskTitle,
      this.taskDesc,
      this.dateStart,
      this.dateEnd,
      this.reminder});

  Map<String, dynamic> toJson() {
    return {
      "task_title": taskTitle,
      "task_desc": taskDesc,
      "task_date_start": dateStart,
      "task_date_end": dateEnd,
      "task_reminder": reminder
    };
  }
}

String AddTaskModelToJson(AddTaskModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
