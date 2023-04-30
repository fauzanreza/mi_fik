import 'dart:convert';

// Usecase add feedback
class FeedbackModel {
  String fbBody;
  int rate;
  String suggest;

  FeedbackModel({this.fbBody, this.rate, this.suggest});

  Map<String, dynamic> toJson() {
    return {
      "feedback_body": fbBody,
      "feedback_rate": rate,
      "feedback_suggest": suggest,
    };
  }
}

String feedbackModelToJson(FeedbackModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
