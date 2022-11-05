import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Model/Content.dart';
import 'package:mi_fik/main.dart';

class ContentService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<ContentModel>> getAllContent() async {
    final response =
        await client.get(Uri.parse("${baseUrl}/api/content?page=1"));
    if (response.statusCode == 200) {
      return ContentModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }

  Future<List<ContentModel>> getContent() async {
    final response =
        await client.get(Uri.parse("${baseUrl}/api/content/${passIdContent}"));
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

  Future<bool> addContent(ContentModel data) async {
    final response = await client.post(
      Uri.parse("${baseUrl}/api/content/create/${passIdUser}"),
      headers: {"content-type": "application/json"},
      body: ContentModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
