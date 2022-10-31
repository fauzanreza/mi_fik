import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Model/Content.dart';
import 'package:mi_fik/main.dart';

class ContentService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<ContentModel>> getAllContent() async {
    final response = await client.get(Uri.parse("${baseUrl}/api/content"));
    if (response.statusCode == 200) {
      return ContentModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<ContentModel>> getAllSchedule() async {
    //Should join w/ task
    final response = await client.get(Uri.parse(
        "${baseUrl}/api/schedule/${DateFormat("yyyy-MM-dd").format(slctSchedule)}"));
    if (response.statusCode == 200) {
      return ContentModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
