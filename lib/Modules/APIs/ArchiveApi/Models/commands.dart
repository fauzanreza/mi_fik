import 'dart:convert';

// Use case add archive
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

// Use case edit archive
class EditArchiveModel {
  String archiveName;
  String archiveDesc;
  String archiveNameOld;

  EditArchiveModel({this.archiveName, this.archiveDesc, this.archiveNameOld});

  Map<String, dynamic> toJson() {
    return {
      "archive_name": archiveName,
      "archive_name_old": archiveNameOld,
      "archive_desc": archiveDesc,
    };
  }
}

String editArchiveModelToJson(EditArchiveModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Use case delete archive
class DeleteArchiveModel {
  String archiveName;

  DeleteArchiveModel({this.archiveName});

  Map<String, dynamic> toJson() {
    return {
      "archive_name": archiveName,
    };
  }
}

String deleteArchiveModelToJson(DeleteArchiveModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
