class TagModel {
  //Key
  int id; //Primary

  String tagName;

  DateTime createdAt;
  DateTime updatedAt;

  tagMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['tag_name'] = tagName;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;

    return mapping;
  }
}
