// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

Future<bool> isLoadable(String url) async {
  try {
    final response = await http.head(Uri.parse(url));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
