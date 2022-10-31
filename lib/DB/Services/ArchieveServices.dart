import 'package:http/http.dart' show Client;
import 'package:mi_fik/DB/Model/Archieve.dart';
import 'package:mi_fik/main.dart';

class ArchieveService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<ArchieveModel>> getAllArchieve() async {
    final response =
        await client.get(Uri.parse("${baseUrl}/api/archieve/${passIdUser}"));
    if (response.statusCode == 200) {
      return ArchieveModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
