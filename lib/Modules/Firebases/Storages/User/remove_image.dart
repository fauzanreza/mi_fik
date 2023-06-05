import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteImage {
  Future<bool> deleteImageUser() async {
    final prefs = await SharedPreferences.getInstance();
    final img = prefs.getString('image_key');

    if (img != null && img != "null") {
      final Reference ref = FirebaseStorage.instance.refFromURL(img);
      try {
        await ref.delete();
        await prefs.setString('image_key', "null");
        return true;
      } catch (e) {
        await prefs.setString('image_key', "null");
        return true;
      }
    } else {
      return false;
    }
  }
}
