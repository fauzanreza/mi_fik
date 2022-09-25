class ContentModel {
  //Key
  late int id; //Primary
  late int idUser; //Foreign->user

  late String contentTitle;
  late String contentDesc;

  late DateTime createdAt;
  late DateTime updatedAt;

  contentMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['id_user'] = idUser;
    mapping['content_title'] = contentTitle;
    mapping['content_desc'] = contentDesc;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;

    return mapping;
  }
}
