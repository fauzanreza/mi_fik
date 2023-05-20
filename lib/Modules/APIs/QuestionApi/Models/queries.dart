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

List<QuestionBodyModel> questionBodyModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<QuestionBodyModel>.from(
      data['data']['data'].map((item) => QuestionBodyModel.fromJson(item)));
}

// Usecase get my faq
class MyQuestionModel {
  String id;

  String msgBody;
  String msgReply; // Nullable
  String questionFrom;
  String questionType;

  // Properties
  String createdAt;

  MyQuestionModel(
      {this.id,
      this.msgBody,
      this.msgReply,
      this.questionFrom,
      this.questionType,
      this.createdAt});

  factory MyQuestionModel.fromJson(Map<String, dynamic> map) {
    return MyQuestionModel(
        id: map["id"],
        questionType: map["question_type"],
        questionFrom: map["question_from"],
        msgBody: map["msg_body"],
        msgReply: map["msg_reply"],
        createdAt: map["created_at"]);
  }
}

List<MyQuestionModel> myQuestionModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<MyQuestionModel>.from(
      data['data']['data'].map((item) => MyQuestionModel.fromJson(item)));
}
