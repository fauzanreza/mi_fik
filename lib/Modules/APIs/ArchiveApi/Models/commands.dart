import 'dart:convert';

class AddArchiveModel {
  String archiveName;
  String archiveDesc;

  AddArchiveModel({this.archiveName, this.archiveDesc});

  Map<String, dynamic> toJson() {
    return {
      "archive_name": archiveName,
      "archive_desc": archiveDesc,
    };
  }
}

String addArchiveModelToJson(AddArchiveModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
