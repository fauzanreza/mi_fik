import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/DictionaryApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DictionaryQueryService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future getDictionaryType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/dictionaries/type/$type"),
        headers: header);
    if (response.statusCode == 200) {
      var arrQtyType = dictionaryTypeModelFromJson(response.body);
      var arrFbcType = dictionaryTypeModelFromJson(response.body);
      var arrAttType = dictionaryTypeModelFromJson(response.body);
      var arrSlcType = dictionaryTypeModelFromJson(response.body);

      if (type == "QST-001") {
        arrQtyType.forEach((e) {
          questionTypeOpt.add(e.slug);
        });
        slctQuestionType = questionTypeOpt.first;
      } else if (type == "FBC-001") {
        arrFbcType.forEach((e) {
          feedbackTypeOpt.add(e.slug);
        });
        slctFeedbackType = feedbackTypeOpt.first;
      } else if (type == "ATT-001") {
        arrAttType.forEach((e) {
          attachmentTypeOpt.add(e.slug);
        });
        slctAttachmentType = attachmentTypeOpt.first;
      } else if (type == "SLC-001") {
        arrSlcType.forEach((e) {
          reminderTypeOpt.add(e.slug);
        });
        slctReminderType = reminderTypeOpt.first;
      }
    } else {
      return null;
    }
  }
}
