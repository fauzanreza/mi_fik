import 'dart:convert';

// Get all tag category
class TagCategoryModel {
  String slug;
  String dctName;

  TagCategoryModel({this.slug, this.dctName});

  factory TagCategoryModel.fromJson(Map<String, dynamic> map) {
    return TagCategoryModel(
      slug: map["slug_name"],
      dctName: map["dct_name"],
    );
  }
}

List<TagCategoryModel> TagCategoryModeFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagCategoryModel>.from(
      data['data'].map((item) => TagCategoryModel.fromJson(item)));
}
