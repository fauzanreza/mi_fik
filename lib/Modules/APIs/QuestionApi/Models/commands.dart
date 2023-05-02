import 'dart:convert';

// Usecase post question faq
class AddQuestionModel {
  String quType;
  String quBody;

  AddQuestionModel({this.quType, this.quBody});

  Map<String, dynamic> toJson() {
    return {
      "question_type": quType,
      "question_body": quBody,
    };
  }
}

String addQuestionModelToJson(AddQuestionModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
