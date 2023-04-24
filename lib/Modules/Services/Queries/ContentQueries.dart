import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Variables/global.dart';

class ContentQueriesService {
  final String baseUrl = "https://mifik.id";
  Client client = Client();

  // Future<List<ContentModel>> getAllContent(tag, order, date, find, page) async {
  //   //Helpers
  //   String finds = await getFind(find);

  //   final response = await client.get(Uri.parse(
  //       "$baseUrl/api/v2/content/slug/$tag/order/$order/date/$date/find/$finds?page=$page"));
  //   if (response.statusCode == 200) {
  //     return ContentModelFromJsonWPaginate(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  // Future<List<ContentModel>> getContent(slug) async {
  //   final response =
  //       await client.get(Uri.parse("$baseUrl/api/v1/content/slug/$slug"));
  //   if (response.statusCode == 200) {
  //     return ContentModelFromJson(response.body);
  //   } else {
  //     return null;
  //   }
  // }

  Future<List<ContentModel>> getAllSchedule() async {
    //Should join w/ task
    final response = await client.get(Uri.parse(
        "$baseUrl/api/schedule/${DateFormat("yyyy-MM-dd").format(slctSchedule)}"));
    if (response.statusCode == 200) {
      return ContentModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<ContentModel>> getContentArchive() async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/schedule/my/$selectedArchiveId"));
    if (response.statusCode == 200) {
      return ContentModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
