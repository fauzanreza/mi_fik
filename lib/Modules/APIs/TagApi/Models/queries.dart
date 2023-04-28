import 'dart:convert';

// Usecase Get all tag category
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

List<TagCategoryModel> TagCategoryModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagCategoryModel>.from(
      data['data'].map((item) => TagCategoryModel.fromJson(item)));
}

// Usecase Get all tag category
class TagAllModel {
  String slug;
  String tagName;

  TagAllModel({this.slug, this.tagName});

  factory TagAllModel.fromJson(Map<String, dynamic> map) {
    return TagAllModel(
      slug: map["slug_name"],
      tagName: map["tag_name"],
    );
  }
}

List<TagAllModel> TagAllModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagAllModel>.from(
      data['data']['data'].map((item) => TagAllModel.fromJson(item)));
}
