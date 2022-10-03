class ContentModel {
  //Key
  int id; //Primary
  int idUser; //Foreign->user

  String contentTitle;
  String contentDesc;

  DateTime createdAt;
  DateTime updatedAt;

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
