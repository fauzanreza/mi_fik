// Usecase get dictionary type
import 'dart:convert';

class DictionaryTypeModel {
  String slug;
  String name;

  DictionaryTypeModel({this.slug, this.name});

  factory DictionaryTypeModel.fromJson(Map<String, dynamic> map) {
    return DictionaryTypeModel(
      slug: map["slug_name"],
      name: map["dct_name"],
    );
  }
}

List<DictionaryTypeModel> dictionaryTypeModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<DictionaryTypeModel>.from(
      data['data'].map((item) => DictionaryTypeModel.fromJson(item)));
}
