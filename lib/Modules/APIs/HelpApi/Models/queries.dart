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
