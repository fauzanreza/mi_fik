import 'package:firebase_storage/firebase_storage.dart';

class DeleteImageContent {
  Future<bool> deleteImageContent(String img) async {
    if (img != null && img != "null") {
      final Reference ref = FirebaseStorage.instance.refFromURL(img);
      try {
        await ref.delete();
        return true;
      } catch (e) {
        return e;
      }
    } else {
      return false;
    }
  }
}
