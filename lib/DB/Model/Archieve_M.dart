class ArchieveModel {
  //Key
  int id; //Primary
  int idUser; //Foreign

  String archieveName;

  DateTime createdAt;
  DateTime updatedAt;

  ArchieveMap() {
    var mapping = <String, dynamic>{};

    mapping['id'] = id;
    mapping['id_user'] = idUser;
    mapping['archieve_name'] = archieveName;
    mapping['created_at'] = createdAt;
    mapping['updated_at'] = updatedAt;

    return mapping;
  }
}
