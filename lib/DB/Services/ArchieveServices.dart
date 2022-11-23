import 'package:http/http.dart' show Client;
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/main.dart';

class ArchieveService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<ArchieveModel>> getAllArchieve() async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/archieve/$passIdUser"));
    if (response.statusCode == 200) {
      return ArchieveModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> addArchive(ArchieveModel data) async {
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

  Future<bool> editArchive(ArchieveModel data, id) async {
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
}
