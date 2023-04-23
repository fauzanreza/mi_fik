import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Archive/Archive.dart';
import 'package:mi_fik/Modules/Variables/dummy.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/main.dart';

class ArchieveService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<ArchiveModel>> getAllArchieve() async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/archieve/$passIdUser"));
    if (response.statusCode == 200) {
      return ArchieveModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> addArchive(ArchiveModel data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/archieve/create/$passIdUser"),
      headers: {"content-type": "application/json"},
      body: ArchieveModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

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
