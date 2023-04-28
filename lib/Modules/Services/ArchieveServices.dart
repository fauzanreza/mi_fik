import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Archive/Archive.dart';

class ArchieveService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<bool> editArchive(ArchiveModel data, id) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/archieve/edit/$id"),
      headers: {"content-type": "application/json"},
      body: ArchieveModelToJson(data),
    );
    if (response.statusCode == 201) {
      //Must return 2 different message
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteArchive(ArchiveModel data, id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/archieve/delete/$id"),
      headers: {"content-type": "application/json"},
      body: ArchieveModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
