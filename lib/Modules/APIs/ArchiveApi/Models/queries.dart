// Usecase get my profile
import 'dart:convert';

class ArchiveModel {
  String slug;
  String archiveName;
  String archiveDesc;

  ArchiveModel({this.slug, this.archiveName, this.archiveDesc});

  factory ArchiveModel.fromJson(Map<String, dynamic> map) {
    return ArchiveModel(
      slug: map["slug_name"],
      archiveName: map["archive_name"],
      archiveDesc: map["archive_desc"],
    );
  }
}

List<ArchiveModel> archiveModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ArchiveModel>.from(
      data['data'].map((item) => ArchiveModel.fromJson(item)));
}
