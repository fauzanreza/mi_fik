// Usecase get my profile
import 'dart:convert';

class ArchiveModel {
  String slug;
  String archiveName;
  String archiveDesc;
  int found;
  int totalEvent;
  int totalTask;

  ArchiveModel(
      {this.slug,
      this.archiveName,
      this.archiveDesc,
      this.totalEvent,
      this.totalTask,
      this.found});

  factory ArchiveModel.fromJson(Map<String, dynamic> map) {
    return ArchiveModel(
        slug: map["slug_name"],
        archiveName: map["archive_name"],
        archiveDesc: map["archive_desc"],
        totalEvent: map["total_event"],
        totalTask: map["total_task"],
        found: map["found"]);
  }
}

List<ArchiveModel> archiveModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<ArchiveModel>.from(
      data['data'].map((item) => ArchiveModel.fromJson(item)));
}
