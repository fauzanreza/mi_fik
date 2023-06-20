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

List<TagCategoryModel> tagCategoryModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagCategoryModel>.from(
      data['data'].map((item) => TagCategoryModel.fromJson(item)));
}

// Usecase Get my tag
class MyTagModel {
  String slug;
  String tagName;

  MyTagModel({this.slug, this.tagName});

  factory MyTagModel.fromJson(Map<String, dynamic> map) {
    return MyTagModel(
      slug: map["slug_name"],
      tagName: map["tag_name"],
    );
  }
}

List<MyTagModel> myTagModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<MyTagModel>.from(
      data['data'].map((item) => MyTagModel.fromJson(item)));
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

List<TagAllModel> tagAllModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<TagAllModel>.from(
      data['data']['data'].map((item) => TagAllModel.fromJson(item)));
}
