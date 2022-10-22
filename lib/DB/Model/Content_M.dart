class ContentModel {
  //Key
  int id; //Primary
  int idUser; //Foreign->user

  String contentTitle;
  String contentDesc;
  var contentTag;
  var contentLoc;

  DateTime createdAt;
  DateTime updatedAt;
  DateTime dateStart;
  DateTime dateEnd;

  contentMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['id_user'] = idUser;
    mapping['content_title'] = contentTitle;
    mapping['content_desc'] = contentDesc;
    mapping['content_tag'] = contentTag;
    mapping['content_loc'] = contentLoc;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;
    mapping['content_date_start'] = dateStart;
    mapping['content_date_end'] = dateEnd;

    return mapping;
  }
}
