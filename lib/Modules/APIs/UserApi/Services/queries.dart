import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/UserApi/Models/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Usecase get profile
class UserQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<UserProfileModel>> getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response =
        await client.get(Uri.parse("$emuUrl/api/v1/user/"), headers: header);
    if (response.statusCode == 200) {
      return UserProfileModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
