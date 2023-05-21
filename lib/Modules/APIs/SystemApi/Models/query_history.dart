import 'dart:convert';

class HistoryModel {
  //Key
  String id; //Primary

  String historyType;
  String historyBody;
  String createdAt;

  HistoryModel({
    this.id,
    this.historyType,
    this.historyBody,
    this.createdAt,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> map) {
    return HistoryModel(
        id: map["id"],
        historyType: map["history_type"],
        historyBody: map["history_body"],
        createdAt: map["created_at"]);
  }
}

List<HistoryModel> historyJsonWPaginate(String jsonData) {
  final data = json.decode(jsonData);
  return List<HistoryModel>.from(
      data['data']['data'].map((item) => HistoryModel.fromJson(item)));
}
