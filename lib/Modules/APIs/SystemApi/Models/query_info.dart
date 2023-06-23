import 'dart:convert';

class InfoModel {
  String infoType;
  String infoBody;
  String infoLocation;

  InfoModel({
    this.infoType,
    this.infoBody,
    this.infoLocation,
  });

  factory InfoModel.fromJson(Map<String, dynamic> map) {
    return InfoModel(
        infoType: map["info_type"],
        infoBody: map["info_body"],
        infoLocation: map["info_location"]);
  }
}

InfoModel infoModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return InfoModel.fromJson(data['data']);
}
