import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';

class HelpQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<HelpTypeModel>> getHelpType() async {
    final header = {
      'Accept': 'application/json',
    };

    final response =
        await client.get(Uri.parse("$emuUrl/api/v1/help"), headers: header);
    if (response.statusCode == 200) {
      return HelpTypeModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
