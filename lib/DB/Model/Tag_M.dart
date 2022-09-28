class TagModel {
  //Key
  late int id; //Primary

  late String tagName;

  late DateTime createdAt;
  late DateTime updatedAt;

  tagMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['tag_name'] = tagName;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;

    return mapping;
  }
}
