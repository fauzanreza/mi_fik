import 'dart:convert';

// Usecase get all help type
class HelpTypeModel {
  String helpType;

  HelpTypeModel({this.helpType});

  factory HelpTypeModel.fromJson(Map<String, dynamic> map) {
    return HelpTypeModel(helpType: map["help_type"]);
  }
}

List<HelpTypeModel> HelpTypeModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<HelpTypeModel>.from(
      data['data'].map((item) => HelpTypeModel.fromJson(item)));
}

// Usecase get all help category and body by type
class HelpBodyModel {
  String helpCategory;
  String helpBody;

  // Failed
  String message;

  HelpBodyModel({this.helpCategory, this.helpBody, this.message});

  factory HelpBodyModel.fromJson(Map<String, dynamic> map) {
    return HelpBodyModel(
        helpCategory: map["help_category"],
        helpBody: map["help_body"],
        message: map["message"]);
  }
}

List<HelpBodyModel> HelpBodyModelFromJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<HelpBodyModel>.from(
      data['data']['data'].map((item) => HelpBodyModel.fromJson(item)));
}
