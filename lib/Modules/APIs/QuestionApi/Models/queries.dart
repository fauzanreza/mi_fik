import 'dart:convert';

// Usecase get all question / FAQ
class QuestionBodyModel {
  String questionBody;
  String questionAnswer;
  String questionType;

  QuestionBodyModel(
      {this.questionBody, this.questionAnswer, this.questionType});

  factory QuestionBodyModel.fromJson(Map<String, dynamic> map) {
    return QuestionBodyModel(
        questionBody: map["question_body"],
        questionAnswer: map["question_answer"],
        questionType: map["question_type"]);
  }
}

List<QuestionBodyModel> QuestionBodyModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<QuestionBodyModel>.from(
      data['data']['data'].map((item) => QuestionBodyModel.fromJson(item)));
}
